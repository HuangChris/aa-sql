require 'sqlite3'
require 'singleton'
require 'byebug'


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

  def self.method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name.start_with?("find_by_")
      column_names = method_name[("find_by_".length)..-1].split("_and_")

      unless column_names.length == args.length
        raise 'unexpected # of arguments'
      end

      conditions = {}
      column_names.each_with_index do |col, i|
        conditions[col] = args[i]
      end

      options = conditions.map do |col, val|
        "#{col} = #{stringify(val)}"
      end
      options.join(" AND ")

      self.where(options)
    else
      super
    end
  end

  def self.where(options)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        #{options}
    SQL
    data.map{ |record| self.new(record) }
  end

  def save
    if @id.nil?
      insert
    else
      update
    end
  end

  def all
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
    SQL

    data.map { |record| self.class.new(record) }
  end

  private

  def update
    db = QuestionsDatabase.instance
    variables = instance_variables.map do |var|
      "#{var.to_s.sub(/@/, "")} = #{stringify(instance_variable_get(var))}"
    end
      db.execute(<<-SQL, id: @id)
        UPDATE
          #{self.class::TABLE_NAME}
        SET
          #{variables.join(", ")}
        WHERE
          id = :id
      SQL
  end
  

  def insert
    db = QuestionsDatabase.instance
    column_names = instance_variables.map { |var| "#{var.to_s.sub(/@/, "")}" }.drop(1)
    values = instance_variables.map { |var| "#{stringify(instance_variable_get(var))}" }.drop(1)

    db.execute(<<-SQL)
      INSERT INTO
        #{self.class::TABLE_NAME}(#{column_names.join(", ")})
      VALUES
        (#{values.join(", ")})
    SQL

    @id = db.last_insert_row_id
  end

  def stringify(var)
    var.is_a?(String) ?  "'#{var}'" : "#{var}"
  end

end
