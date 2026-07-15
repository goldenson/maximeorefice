require 'telegram/bot'
require 'sqlite3'
require 'dotenv/load'

class CrossfitBot
  DB_FILE = '_data/database.sqlite'

  def initialize
    @token = ENV.fetch('TELEGRAM_CROSSFIT_TOKEN')
    @chat_id = ENV.fetch('CROSSFIT_CHAT_ID')
  end

  def execute
    Telegram::Bot::Client.run(token) do |bot|
      prompt_message_id = send_daily_message(bot).message_id

      bot.listen do |message|
        next unless message.is_a?(Telegram::Bot::Types::CallbackQuery)
        next unless message.message.message_id == prompt_message_id

        date_today = Time.now.strftime('%Y-%m-%d')
        showup = message.data == 'yes' ? 1 : 0
        save_training(date_today, showup)

        begin
          mark_selected_answer(bot, message)
        rescue Telegram::Bot::Exceptions::ResponseError => e
          puts "Erreur lors de la mise à jour du clavier: #{e.message}"
        end

        begin
          bot.api.answer_callback_query(callback_query_id: message.id, text: 'Merci pour votre réponse !')
        rescue Telegram::Bot::Exceptions::ResponseError => e
          puts "Erreur lors de la réponse au callback_query: #{e.message}"
        end

        count = monthly_training_count
        text = if showup == 1
                 "Bravo champion ! Tu t'es entraîné #{count} fois ce mois-ci 💪"
               else
                 "Dommage, la fiotte ! Tu t'es entraîné #{count} fois ce mois-ci."
               end
        bot.api.send_message(chat_id: message.message.chat.id, text: text)
        bot.stop
      end
    end
  end

  private

  attr_reader :token, :chat_id

  def save_training(date, showup)
    db = SQLite3::Database.new(DB_FILE)
    db.execute(
      "INSERT INTO trainings (date, showup) VALUES (?, ?) ON CONFLICT(date) DO UPDATE SET showup = excluded.showup",
      [date, showup]
    )
  ensure
    db&.close
  end

  def monthly_training_count
    db = SQLite3::Database.new(DB_FILE)
    month_prefix = Time.now.strftime('%Y-%m')
    db.execute("SELECT COUNT(*) FROM trainings WHERE showup = 1 AND date LIKE ?", ["#{month_prefix}%"]).first.first
  ensure
    db&.close
  end

  def mark_selected_answer(bot, message)
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [
        [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: message.data == 'yes' ? '✅ Oui' : 'Oui', callback_data: 'yes'),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: message.data == 'no' ? '✅ Non' : 'Non', callback_data: 'no')
        ]
      ]
    )

    bot.api.edit_message_reply_markup(
      chat_id: message.message.chat.id,
      message_id: message.message.message_id,
      reply_markup: markup
    )
  end

  # Envoyer un message à tous les utilisateurs
  def send_daily_message(bot)
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [
        [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Oui', callback_data: 'yes'),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Non', callback_data: 'no')
        ]
      ]
    )

    bot.api.send_message(chat_id: chat_id, text: "Est-ce que tu t'es entraîné aujourd’hui ?", reply_markup: markup)
  end
end
