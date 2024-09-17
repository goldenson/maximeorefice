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
    @monthly_birthdays = {}
    @token = ENV.fetch('TELEGRAM_TOKEN')
    @group_id = ENV.fetch('GROUP_ID')
  end

  def execute
    load_file
    find_today_birthday
    find_monthly_birthdays
    send_message_to_telegram unless @today_birthday.nil?
    send_monthly_birthdays_to_telegram unless @monthly_birthdays.nil?
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

  def find_monthly_birthdays
    @monthly_birthdays = birthdays.select do |b|
      "#{b['date'][0..1]}".to_i == Date.today.month
    end
  end

  def send_message_to_telegram
    text = "🎉 Aujourd'hui c'est l'anniversaire de #{today_birthday['name'].join(' & ')}"

    bot.api.send_message(chat_id: group_id, text: text)
  end

  def send_monthly_birthdays_to_telegram
    return unless Date.today.day == 1

    text = "🎉 En #{Date.today.strftime("%B")}, nous allons fêter les anniversaires de: \n"

    @monthly_birthdays.each do |birthday|
      birthday_date = Date.parse("#{Date.today.year}-#{birthday['date']}")
      text << "- #{birthday['name'].join(' & ')}, le #{birthday_date.strftime("%A %d %B")} \n"
    end

    bot.api.send_message(chat_id: group_id, text: text)
  end

  def bot
    bot ||= Telegram::Bot::Client.new(token)
  end
end

begin
  bot = BirthDayBot.new
  bot.execute
rescue Telegram::Bot::Exceptions::ResponseError, KeyError
  puts "CI VARIABLES are only set for the scheduled pipeline"
end
