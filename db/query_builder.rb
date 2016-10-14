require_relative('query_runner')

class QueryBuilder

  def self.all_records_sql(table_name)
    return "SELECT * FROM #{table_name}"
  end

  def self.all_where_sql(table_name, conditions_hash)
    conditions_array = []

    for column, value in conditions_hash
      value_sql = self.value_to_sql(value)
      sql = "#{column} = #{value_sql}"
      conditions_array.push(sql)
    end

    condition_statement = conditions_array.join(" AND ")
    select_statement = self.all_records_sql(table_name)

    return "#{select_statement} WHERE #{condition_statement}"
  end

  def self.insert_sql( table_name, values_hash )
    columns_array = []
    values_array = []

    for column, value in values_hash
      columns_array.push(column)
      value_sql = self.value_to_sql( value )
      values_array.push( value_sql )
    end

    columns_sql = columns_array.join(", ")
    values_sql = values_array.join(", ")

    return "INSERT INTO #{table_name}(#{columns_sql}) VALUES (#{values_sql})"
  end

  def self.value_to_sql( value )
    value_class = value.class().to_s()
    case value_class
    when 'Fixnum'
      sql = value
    when 'Float'
      sql = value
    when 'String'
      sql = "'#{value}'"
    else
      raise(TypeError, "Error: Un-supported data type #{value_class}.")
    end

    return sql
  end

end
