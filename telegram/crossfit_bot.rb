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
      send_daily_message(bot)

      bot.listen do |message|
        next unless message.is_a?(Telegram::Bot::Types::CallbackQuery)

        date_today = Time.now.strftime('%Y-%m-%d')
        showup = message.data == 'yes' ? 1 : 0
        save_training(date_today, showup)

        begin
          bot.api.answer_callback_query(callback_query_id: message.id, text: 'Merci pour votre réponse !')
        rescue Telegram::Bot::Exceptions::ResponseError => e
          puts "Erreur lors de la réponse au callback_query: #{e.message}"
        end

        bot.api.send_message(chat_id: message.message.chat.id, text: showup == 1 ? 'Bravo champion!' : 'Dommage, la fiotte !')
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

  # Envoyer un message à tous les utilisateurs
  def send_daily_message(bot)
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [
        [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Oui', callback_data: 'yes')],
        [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Non', callback_data: 'no')]
      ]
    )

    bot.api.send_message(chat_id: chat_id, text: "Est-ce que tu t'es entraîné aujourd’hui ?", reply_markup: markup)
  end
end
