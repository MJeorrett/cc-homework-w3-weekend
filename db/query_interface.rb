require_relative('query_builder')

class QueryInterface

  def self.all_records( table_name )
    sql = QueryBuilder.all_records_sql( table_name )
    return QueryRunner.run( sql )
  end

  def self.all_where( table_name, conditions_hash )
    sql = QueryBuilder.all_where_sql( table_name, conditions_hash )
    return QueryRunner.run( sql )
  end

  def self.insert( table_name, values_hash )
    sql = QueryBuilder.insert_sql( table_name, values_hash )
    return QueryRunner.run( sql ).first()['id']
  end

  def self.update( table_name, values_hash, id )
    sql = QueryBuilder.update_sql( table_name, values_hash, id)
    return QueryRunner.run( sql )
  end

  def self.delete_all( table_name )
    sql = QueryBuilder.delete_all_sql( table_name )
    return QueryRunner.run( sql )
  end

  def self.delete_with_id( table_name, id )
    sql = QueryBuilder.delete_with_id_sql( table_name, id )
    return QueryRunner.run( sql )
  end

  def self.many_to_many( table_name, join_column, join_table, other_join_column, other_table )
    sql = QueryBuilder.many_to_many_sql( table_name, join_column, join_table, other_join_column, other_table )
    return QueryRunner.run( sql )
  end

  def self.get_table_columns( table_name )
    sql = QueryBuilder.get_table_columns_sql( table_name )
    return QueryRunner.run( sql )
  end

  def self.find_by_id( table_name, id )
    conditions_hash = { id: id }
    sql = QueryBuilder.all_where_sql( table_name, conditions_hash )
    return QueryRunner.run( sql )
  end

end
