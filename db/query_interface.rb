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

  def self.get_table_columns( table_name )
    sql = QueryBuilder.get_table_columns_sql( table_name )
    return QueryRunner.run( sql )
  end

end
