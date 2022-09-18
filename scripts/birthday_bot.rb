# frozen_string_literal: true

require 'yaml'
require 'date'
require 'telegram/bot'

class BirthDayBot
  BIRTHDAY_FILE = '_data/_birthdays.yml'

  def initialize
    @birthdays = {}
    @today_birthday = {}
    @token = ENV.fetch('TELEGRAM_TOKEN')
    @chat_id = ENV.fetch('CHAT_ID')
  end

  def execute
    load_file
    find_today_birthday
    send_message_to_telegram
  end

  private

  def load_file
    path = File.expand_path(BIRTHDAY_FILE)

    @birthdays = YAML.load_file(path)
  end

  def find_today_birthday
    @today_birthday = @birthdays.find do |b|
      Date.parse("#{Date.today.year}-#{b['date']}") == Date.today
    end
  end

  def send_message_to_telegram
    Telegram::Bot::Client.run(@token) do |bot|
      text = "🎉 Aujourd'hui c'est l'anniversaire de #{@today_birthday['name'].join(' & ')}"
      bot.api.send_message(chat_id: @chat_id, text: text)
    end
  end
end

begin
  bot.execute
  bot = BirthDayBot.new
rescue Telegram::Bot::Exceptions::ResponseError
  puts "CI VARIABLES are only set for the scheduled pipeline"
end
