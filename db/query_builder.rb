require_relative('query_runner')

class QueryBuilder

  DB_NAME = 'cinema'

  def self.all_records( table_name )
    sql = self.all_records_sql( table_name )
    return QueryRunner.run( sql )
  end

  def self.all_where( table_name, conditions_hash )
    sql = self.all_where_sql( table_name, conditions_hash )
    return QueryRunner.run( sql )
  end

  def self.insert( table_name, values_hash )
    sql = self.insert_sql( table_name, values_hash )
    return QueryRunner.run( sql ).first()['id']
  end

  def self.update( table_name, values_hash, id )
    sql = self.update_sql( table_name, values_hash, id)
    return QueryRunner.run( sql )
  end

  def self.get_table_columns( table_name )
    sql = self.get_table_columns_sql( table_name )
    return QueryRunner.run( sql )
  end

  private

  def self.all_records_sql(table_name)
    return "SELECT * FROM #{table_name}"
  end

  def self.all_where_sql(table_name, conditions_hash)
    select_statement = self.all_records_sql(table_name)
    where_clause = self.where_clause( conditions_hash )

    return "#{select_statement} #{where_clause}"
  end

  def self.where_clause( conditions_hash )
    conditions_array = []

    for column, value in conditions_hash
      value_sql = self.value_to_sql(value)
      sql = "#{column} = #{value_sql}"
      conditions_array.push(sql)
    end

    conditions_sql = conditions_array.join(" AND ")

    return "WHERE #{conditions_sql}"
  end

  def self.insert_sql( table_name, values_hash )
    sql_arrays = self.get_columns_and_values_sql( values_hash )

    columns_sql = sql_arrays[:columns_array].join(", ")
    values_sql = sql_arrays[:values_array].join(", ")

    return "INSERT INTO #{table_name}(#{columns_sql}) VALUES (#{values_sql}) RETURNING id"
  end

  def self.update_sql( table_name, values_hash, id)
    sql_arrays = self.get_columns_and_values_sql( values_hash )
    columns_array = sql_arrays[:columns_array]
    values_array = sql_arrays[:values_array]

    assignments_array = []
    i_max = values_hash.length - 1
    for i in (0..i_max)
      assignments_array.push("#{columns_array[i]} = #{values_array[i]}")
    end

    assignments_sql = assignments_array.join(", ")
    where_clause = self.where_clause( id: id )

    return "UPDATE #{table_name} SET #{assignments_sql} #{where_clause}"
  end

  def self.get_columns_and_values_sql( values_hash )
    columns_array = []
    values_array = []

    for column, value in values_hash
      columns_array.push(column)
      value_sql = self.value_to_sql( value )
      values_array.push( value_sql )
    end

    return {
      columns_array: columns_array,
      values_array: values_array
    }
  end

  def self.get_table_columns_sql( table_name )
    columns_table_name = "#{DB_NAME}.information_schema.columns"
    select_statement = self.all_records_sql(columns_table_name)
    condition = { table_name: table_name }
    where_clause = self.where_clause( condition )
    return "#{select_statement} #{where_clause}"
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
