#!/usr/bin/env ruby

require 'dotenv/load'
require 'net/http'
require 'uri'
require 'json'
require 'time'

# === CREDENTIALS ===
TELEGRAM_TOKEN = ENV['TELEGRAM_WEALTH_TOKEN']
CHAT_ID        = ENV['WEALTH_CHAT_ID']

# === CONFIG: TICKERS + POSITION SIZE FROM ENV ===
# Example: export HOLDINGS_JSON='{"VT":500000,"AAPL":200000,"TSLA":150000,"BTC-USD":150000}'
holdings_json = ENV['HOLDINGS_JSON'] || '{}'
HOLDINGS = JSON.parse(holdings_json).transform_values(&:to_i).freeze
raise "HOLDINGS_JSON missing or invalid" if HOLDINGS.empty?

TOTAL_START_USD = HOLDINGS.values.sum
TICKERS = HOLDINGS.keys

# === HELPERS ===
def http_get(url)
  uri = URI(url)
  http = Net::HTTP.new(uri.hostname, uri.port)
  http.use_ssl = true
  http.open_timeout = 5
  http.read_timeout = 5
  req = Net::HTTP::Get.new(uri)
  req['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
  req['Accept'] = 'application/json'
  res = http.request(req)
  res.is_a?(Net::HTTPSuccess) ? res.body : nil
end

def get_closes(ticker, start_time, end_time, interval: '1d')
  url = "https://query1.finance.yahoo.com/v8/finance/chart/#{ticker}?period1=#{start_time}&period2=#{end_time}&interval=#{interval}"
  body = http_get(url) || []
  data = JSON.parse(body)['chart']['result']&.first || []
  timestamps = data['timestamp'] || []
  closes = data['indicators']['quote'][0]['close'] || []
  timestamps.zip(closes).select { |_, c| !c.nil? }.map { |t, c| [Time.at(t).utc, c] }
end

# === FUN OUTPUT WITH :emoji: (Telegram renders these) ===
def fun_ytd(ytd)
  case ytd
  when 50..     then "🚀 *+#{ytd}%* — Moonshot!"
  when 20..50   then "🔥 *+#{ytd}%* — On fire!"
  when 10..20   then "💪 *+#{ytd}%* — Strong!"
  when 0..10    then "🟢 *+#{ytd}%* — Green!"
  when -10..0   then "😑 *#{ytd}%* — Flat..."
  when -20..-10 then "‼️ *#{ytd}%* — Dip!"
  when -50..-20 then "😵 *#{ytd}%* — Ouch!"
  else              "💀 *#{ytd}%* — Bloodbath!"
  end
end

def fun_weekly(wk)
  case wk
  when 5..     then "🌟 *+#{wk}%*"
  when 2..5    then "📈 *+#{wk}%*"
  when 0..2    then "🟢 *+#{wk}%*"
  when -2..0   then "🟡 *#{wk}%*"
  when -5..-2  then "📉 *#{wk}%*"
  else              "🔻 *#{wk}%*"
  end
end

def fun_value(current, gain)
  if gain > 100_000
    "💰 **$#{format_usd(current)}** (+$#{format_usd(gain)})"
  elsif gain > 0
    "🌱 **$#{format_usd(current)}** (+$#{format_usd(gain)})"
  elsif gain > -50_000
    "😅 **$#{format_usd(current)}** (#{'-'}$#{format_usd(gain.abs)})"
  else
    "😵 **$#{format_usd(current)}** (-$#{format_usd(gain.abs)})"
  end
end

# === CORE: YTD + WEEKLY + VALUE ===
def compute_moves(ticker)
  now = Time.now.utc
  year_start = Time.utc(2025, 1, 1).to_i

  points = get_closes(ticker, year_start, now.to_i, interval: '1d')
  return { ytd: 'N/A', weekly: 'N/A', current_value: 'N/A', gain: 'N/A' } if points.size < 2

  first_point = points.find { |t, _| t >= Time.utc(2025, 1, 1) } || points.first
  start_price = first_point[1]
  current_price = points.last[1]
  return { ytd: 'N/A', weekly: 'N/A', current_value: 'N/A', gain: 'N/A' } if start_price.nil? || current_price.nil?

  fridays = points.select { |t, _| t.wday == 5 }.last(2)
  fridays = points.last(2) if fridays.size < 2
  return { ytd: 'N/A', weekly: 'N/A', current_value: 'N/A', gain: 'N/A' } if fridays.size < 2

  prev_close = fridays[-2][1]
  last_close = fridays[-1][1]
  return { ytd: 'N/A', weekly: 'N/A', current_value: 'N/A', gain: 'N/A' } if prev_close.nil? || last_close.nil?

  ytd_pct = ((current_price / start_price) - 1) * 100
  weekly_pct = ((last_close - prev_close) / prev_close) * 100

  start_value = HOLDINGS[ticker]
  current_value = (start_value * (current_price / start_price)).round(0).to_i
  gain_usd = current_value - start_value

  {
    ytd: ytd_pct.round(2),
    weekly: weekly_pct.round(2),
    current_value: current_value,
    gain: gain_usd
  }
end

def send_telegram_message(text)
  uri = URI("https://api.telegram.org/bot#{TELEGRAM_TOKEN}/sendMessage")
  Net::HTTP.post_form(uri, 'chat_id' => CHAT_ID, 'text' => text, 'parse_mode' => 'Markdown')
end

def format_usd(num)
  num.abs.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
end

# === MAIN ===
lines = ["*Weekly Wealth Update* — #{Time.now.strftime('%Y-%m-%d %H:%M')} CET"]
total_current = 0
total_gain = 0

TICKERS.each do |ticker|
  m = compute_moves(ticker)
  ytd_str = m[:ytd] == 'N/A' ? 'N/A' : fun_ytd(m[:ytd])
  weekly_str = m[:weekly] == 'N/A' ? 'N/A' : fun_weekly(m[:weekly])
  value_str = m[:current_value] == 'N/A' ? 'N/A' : fun_value(m[:current_value], m[:gain])

  lines << "#{ticker}: #{ytd_str} YTD | #{weekly_str} wk"
  lines << "  → #{value_str}"

  total_current += m[:current_value] == 'N/A' ? 0 : m[:current_value]
  total_gain += m[:gain] == 'N/A' ? 0 : m[:gain]
end

# Allocation footer
alloc = TICKERS.map { |t| "#{t}: #{(HOLDINGS[t].fdiv(TOTAL_START_USD)*100).round(1)}%" }.join(' | ')

# Fun total footer
total_pct = (total_gain.to_f / TOTAL_START_USD * 100).round(2)
footer = case total_pct
         when 50..     then "🌙 *+$#{format_usd(total_gain)}* (#{total_pct}%) — TO THE MOON!"
         when 20..50   then "🔥 *+$#{format_usd(total_gain)}* (#{total_pct}%) — BULL RUN!"
         when 10..20   then "💪 *+$#{format_usd(total_gain)}* (#{total_pct}%) — STRONG GAINS!"
         when 0..10    then "✅ *+$#{format_usd(total_gain)}* (#{total_pct}%) — IN THE GREEN!"
         when -10..0   then "😐 *$#{format_usd(total_current)}* (#{total_pct}%) — HOLDING..."
         when -20..-10 then "⚠️ *$#{format_usd(total_current)}* (#{total_pct}%) — CORRECTION!"
         else              "💀 *$#{format_usd(total_current)}* (#{total_pct}%) — CRYPTO WINTER?"
         end

lines << ""
lines << "_#{alloc}_"
lines << ""
lines << "*Total:* #{footer}"

msg = lines.join("\n")
send_telegram_message(msg)
