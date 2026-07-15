# frozen_string_literal: true

require_relative '../telegram/crossfit_bot'

begin
  bot = CrossfitBot.new
  bot.execute
  puts "CrossfitBot executed successfully."
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
