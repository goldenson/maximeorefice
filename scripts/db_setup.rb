require 'sqlite3'

db = SQLite3::Database.new "_data/crossfit.db"

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS trainings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL UNIQUE,
    showup INTEGER NOT NULL CHECK (showup IN (0, 1))
  );
SQL
