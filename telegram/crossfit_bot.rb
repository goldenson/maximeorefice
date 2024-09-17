require 'telegram/bot'
require 'sqlite3'
require 'dotenv/load'

class CrossfitBot
  DB_FILE = '_data/crossfit.db'

  def initialize
    @token = ENV.fetch('TELEGRAM_CROSSFIT_TOKEN')
    @chat_id = ENV.fetch('CROSSFIT_CHAT_ID')
  end

  def execute
    run_bot
  end

  private

  attr_reader :token, :chat_id

  # Ouvrir la base de données SQLite
  def open_db
    SQLite3::Database.new(DB_FILE)
  end

  # Enregistrer ou mettre à jour l'entrée dans la base de données
  def save_training(date, showup)
    db = open_db
    begin
      # Tenter d'insérer une nouvelle entrée
      db.execute("INSERT INTO trainings (date, showup) VALUES (?, ?)", [date, showup])
    rescue SQLite3::ConstraintException
      # Mettre à jour si une entrée avec la même date existe déjà
      db.execute("UPDATE trainings SET showup = ? WHERE date = ?", [showup, date])
    end
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

  def run_bot
    Telegram::Bot::Client.run(token) do |bot|
      send_daily_message(bot)

      bot.listen do |message|
        case message
        when Telegram::Bot::Types::CallbackQuery
          # Déterminer la date actuelle
          date_today = Time.now.strftime('%Y-%m-%d')

          # Déterminer la réponse à enregistrer
          showup = case message.data
                  when 'yes'
                    1
                  when 'no'
                    0
                  else
                    0
                  end

          # Enregistrer ou mettre à jour l'entrée dans la base de données
          save_training(date_today, showup)

          # Répondre à la requête de rappel
          begin
            bot.api.answer_callback_query(callback_query_id: message.id, text: 'Merci pour votre réponse !')
          rescue Telegram::Bot::Exceptions::ResponseError => e
            puts "Erreur lors de la réponse au callback_query: #{e.message}"
          end

          # Envoyer un message de suivi
          bot.api.send_message(chat_id: message.message.chat.id, text: showup == 1 ? 'Bravo champion!' : 'Dommage, la fiotte !')
          bot.stop
        end
      end
    end
  end
end

# Configuration du bot Telegram

begin
  bot = CrossfitBot.new
  bot.execute
rescue Telegram::Bot::Exceptions::ResponseError, KeyError
  puts "CI VARIABLES are only set for the scheduled pipeline"
end
