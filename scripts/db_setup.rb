require 'sqlite3'

db = SQLite3::Database.new "_data/database.sqlite"

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS trainings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL UNIQUE,
    showup INTEGER NOT NULL CHECK (showup IN (0, 1))
  );
SQL

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS health (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL UNIQUE,
    weight REAL NOT NULL,
    imc REAL,
    fat REAL,
    fat_mass REAL,
    lean_mass REAL,
    muscle_mass REAL,
    bmr INTEGER
  );
SQL
