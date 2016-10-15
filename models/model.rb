require_relative('../db/query_interface')

require('pry-byebug')

class Model

  attr_reader :id

  @@joins = []

  def initialize( data )

    @data = data

    self.check_data_matches_columns()

    if data['id'] != nil
      @id = data['id']
      data.delete('id')
    end
  end

  def check_data_matches_columns()
    query_result = QueryInterface.get_table_columns( table_name() )
    column_names = query_result.map { |result| result['column_name'] }

    @data.each_key do |key|
      if !column_names.include?(key.to_s)
        raise(TypeError, "Error in sub-class: #{self.class()}: Key '#{key}' not a column in table '#{self.table_name()}'.")
      end
    end

  end

  def save()
    id = QueryInterface.insert( table_name(), @data )
    @id = id.to_i
  end

  def update()
    QueryInterface.update( table_name(), @data, @id )
  end

  def delete()
    QueryInterface.delete_with_id( table_name(), @id )
  end

# this method is overidden to dynamically create accessors for all columns and joins.
  def method_missing(method_sym, *args)

    many_to_many_data = @@joins.find do |join|
      correct_type = join[:type] == 'many_to_many'
      name_matches = join[:name] == method_sym.to_s
    end

    if many_to_many_data != nil
      response = get_many_to_many( many_to_many_data )
    else

      if method_sym.to_s[-1] == '='
        column = method_sym[0..-2].to_sym
        assign = true
      else
        column = method_sym
        assign = false
      end

      if @data.keys().include?(column)
        if assign
          response = set_column_value( column, args[0] )
        else
          response = get_column_value( method_sym )
        end
      else
        super
      end

    end

    return response
  end

  def get_column_value( column )

    return @data[column]
  end

  def set_column_value( column, new_value )

    @data[column] = args[0]
    return get_column_value( column )
  end

  def get_many_to_many( join_data )

    data = QueryInterface.many_to_many(
      @id,
      join_data[:join_column],
      join_data[:join_table],
      join_data[:other_join_column],
      join_data[:other_table]
    )

    return join_data[:other_class].send( :data_to_objects, data )
  end

  def table_name()
    return self.class().table_name()
  end

  def self.all()
    data = QueryInterface.all_records( table_name() )
    return self.data_to_objects( data )
  end

  def self.find_by_id( id )
    data = QueryInterface.find_by_id( self.table_name(), id )
    return self.data_to_obejct( data )
  end

  def self.delete_all()
    QueryInterface.delete_all( self.table_name() )
  end

  def self.data_to_objects( data )
    return data.map { |record| self.new( record ) }
  end

  def self.data_to_obejct( data )
    return self.data_to_objects( data ).first()
  end

  def self.add_many_to_many_join( name, other_class, join_column, join_table, other_join_column, other_table )

    join_data = {
      name: name,
      other_class: other_class,
      type: 'many_to_many',
      join_column: join_column,
      join_table: join_table,
      other_join_column: other_join_column,
      other_table: other_table
    }

    current_join = @@joins.find { |join| join.name == name }
    @@joins.delete(current_join) if current_join != nil
    @@joins.push( join_data )
  end

  def self.table_name()
    raise "Error in sub-class #{self.class}:  'self.table_name' must be implemented in sub-classes of Model."
  end

end
