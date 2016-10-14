class QueryBuilder

  def self.all_records(table_name)
    return "SELECT * FROM #{table_name}"
  end

  def self.all_where(table_name, conditions_hash)
    conditions_array = []

    for column, value in conditions_hash
      value_sql = self.value_to_sql(value)
      sql = "#{column} = #{value_sql}"
      conditions_array.push(sql)
    end

    condition_statement = conditions_array.join(" AND ")
    select_statement = self.all_records(table_name)

    return "#{select_statement} WHERE #{condition_statement}"
  end

  def self.value_to_sql( value )
    value_class = value.class().to_s()
    case value_class
    when 'Fixnum'
      sql = value
    when 'String'
      sql = "'#{value}'"
    else
      raise(TypeError, "Error: Un-supported data type #{value_class}.")
    end

    return sql
  end

end
