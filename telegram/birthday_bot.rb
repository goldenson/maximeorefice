# frozen_string_literal: true

require 'dotenv/load'
require 'yaml'
require 'date'
require 'telegram/bot'

class BirthDayBot
  BIRTHDAY_FILE = '_data/_birthdays.yml'

  def initialize
    @birthdays = {}
    @today_birthday = {}
    @token = ENV.fetch('TELEGRAM_TOKEN')
    @group_id = ENV.fetch('GROUP_ID')
  end

  def execute
    load_file
    find_today_birthday
    send_message_to_telegram unless @today_birthday.nil?
  end

  private

  attr_reader :birthdays, :today_birthday, :token, :group_id

  def load_file
    path = File.expand_path(BIRTHDAY_FILE)

    @birthdays = YAML.load_file(path)
  end

  def find_today_birthday
    @today_birthday = birthdays.find do |b|
      Date.parse("#{Date.today.year}-#{b['date']}") == Date.today
    end
  end

  def send_message_to_telegram
    Telegram::Bot::Client.run(token) do |bot|
      text = "🎉 Aujourd'hui c'est l'anniversaire de #{today_birthday['name'].join(' & ')}"

      bot.api.send_message(chat_id: group_id, text: text)
    end
  end
end

begin
  bot = BirthDayBot.new
  bot.execute
rescue Telegram::Bot::Exceptions::ResponseError, KeyError
  puts "CI VARIABLES are only set for the scheduled pipeline"
end