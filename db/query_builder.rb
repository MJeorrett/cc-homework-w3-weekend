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

    conditions_string = conditions_array.join(" AND ")

    return "#{self.all_records(table_name)} WHERE #{conditions_string}"
  end

end
