require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    records_and_columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    records_and_columns.first.map{ |column| column.to_sym }
  end

  def self.finalize!

    self.columns.each do |column|
      define_method("#{column.to_s}") { self.attributes[column] }

      define_method("#{column.to_s}=") do |value|
        self.attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.split(/(?=[A..Z])/).join("_").downcase + "s"
  end

  def self.all
    records = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    self.parse_all(records)
  end

  def self.parse_all(results)
    results.map do |record|
      self.new(record)
    end
  end

  def self.find(id)
    records = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = #{id}
    SQL
    self.parse_all(records).first
  end

  def initialize(params = {})
    params.each do |key, value|
      unless self.class.columns.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      end
      attributes[key.to_sym] = value
    end
  end

  def attributes
    @attributes ||= Hash.new
  end

  def attribute_values
    @attributes.values
  end

  def insert
    column_names = self.class.columns.map(&:to_s).join(", ")
    records = DBConnection.execute(<<-SQL, attributes)
      INSERT INTO
        #{self.class.table_name} #{column_names}
      VALUES
        (#{self.class.columns.join(", ")})
    SQL
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
