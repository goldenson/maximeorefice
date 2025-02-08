# frozen_string_literal: true

require_relative '../telegram/birthday_bot'

begin
  bot = BirthDayBot.new
  bot.execute
  puts "BirthdayBot executed successfully."
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
