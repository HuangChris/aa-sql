require 'sqlite3'
require 'singleton'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    @results_as_hash = true
  end
end

class Table
  def self.find_by_id(id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        id = ?
    SQL
  end
end
