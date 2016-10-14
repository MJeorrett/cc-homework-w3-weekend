class QueryBuilder

  def self.all_records(table_name)
    return "SELECT * FROM #{table_name}"
  end

  def self.all_where(table_name, conditions_hash)
    conditions_array = []

    for column, value in conditions_hash
      if value.class == Fixnum
        str = "#{column} = #{value}"
      else
        str = "#{column} = '#{value}'"
      end

      conditions_array.push(str)
    end

    condition_statment = conditions_array.join(" AND ")
    select_statement = self.all_records(table_name)

    return "#{select_statement} WHERE #{condition_statement}"
  end

end
