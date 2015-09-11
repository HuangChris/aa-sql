require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    p params
    if params.is_a?(Hash)
      columns = []
      values = []
      params.each do |key, value|
        columns << key.to_s + " = ?"
        values << value
      end
    end
      records = DBConnection.execute(<<-SQL, values)
        SELECT
          *
        FROM
          #{self.table_name}
        WHERE
          #{columns.join(" AND ")}
      SQL
      self.parse_all(records)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
