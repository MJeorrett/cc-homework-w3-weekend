require_relative('../db/query_interface')

require('pry-byebug')

class Model

  DATA_CASTING_FUNCTIONS = {
    'integer' => :to_i,
    'character varying' => :to_s,
    'numeric' => :to_f,
    'decimal' => :to_f
  }

  attr_reader :id

  @@joins = []

  def initialize( data )

    @data = data

    self.check_data_matches_columns()

    if data['id'] != nil
      @id = data['id'].to_i
      data.delete('id')
    end

    self.cast_data()

  end

  def check_data_matches_columns()

    query_results = QueryInterface.get_table_columns( self.class::TABLE_NAME )
    column_names = query_results.map { |result| result['column_name'] }

    @data.each_key do |key|
      if !column_names.include?(key.to_s)
        raise(TypeError, "Error in sub-class: #{self.class()}: Key '#{key}' not a column in table '#{self.class::TABLE_NAME}'.")
      end
    end

  end

  def cast_data()
    for column_name, value in @data
      sql_data_type = self.class.sql_data_type_for_column( column_name )
      casting_function = DATA_CASTING_FUNCTIONS[sql_data_type]
      if casting_function != nil
        @data[column_name] = @data[column_name].send( casting_function )
      else
        raise( TypeError, "Un-supported sql data type '#{sql_data_type}'.")
      end
    end
  end

  def save()
    id = QueryInterface.insert( self.class::TABLE_NAME, @data )
    @id = id.to_i
  end

  def update()
    QueryInterface.update( self.class::TABLE_NAME, @data, @id )
  end

  def delete()
    QueryInterface.delete_with_id( self.class::TABLE_NAME, @id )
  end

# this method is overidden to dynamically create accessors for all columns and joins.
  def method_missing(method_sym, *args)

    join_data = @@joins.find do |join|
      join[:name] == method_sym.to_s
    end

    if join_data != nil
      case join_data[:type]
      when :many_to_many
        response = self.get_many_to_many( join_data )
      when :one_to_many
        response = self.get_one_to_many ( join_data )
      end
    else

      if method_sym.to_s[-1] == '='
        column = method_sym[0..-2].to_s
        assign = true
      else
        column = method_sym.to_s
        assign = false
      end

      if @data.keys().include?(column)

        if assign
          response = set_column_value( column, args[0] )
        else
          response = get_column_value( column )
        end
      else
        # must call super if method is not dealt with else usual method_missing behaviour is followed
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

  def get_one_to_many( join_data )

    conditions_hash = { join_data[:referencing_column] => @id }

    data = QueryInterface.all_where( join_data[:referencing_table], conditions_hash )

    return join_data[:other_class].send( :data_to_objects, data )
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

  def self.all()
    data = QueryInterface.all_records( self::TABLE_NAME )
    return self.data_to_objects( data )
  end

  def self.find_by_id( id )
    data = QueryInterface.find_by_id( self::TABLE_NAME, id )
    return self.data_to_obejct( data )
  end

  def self.delete_all()
    QueryInterface.delete_all( self::TABLE_NAME )
  end

  def self.data_to_objects( data )
    return data.map { |record| self.new( record ) }
  end

  def self.data_to_obejct( data )
    return self.data_to_objects( data ).first()
  end

  def self.add_one_to_many_join( name, other_class, referencing_column, referencing_table )

    join_data = {
      name: name,
      other_class: other_class,
      type: :one_to_many,
      referencing_column: referencing_column,
      referencing_table: referencing_table
    }

    self.remove_join_with_name( name )
    @@joins.push( join_data )
  end

  def self.add_many_to_many_join( name, other_class, join_column, join_table, other_join_column, other_table )

    join_data = {
      name: name,
      other_class: other_class,
      type: :many_to_many,
      join_column: join_column,
      join_table: join_table,
      other_join_column: other_join_column,
      other_table: other_table
    }

    self.remove_join_with_name( name )
    @@joins.push( join_data )
  end

  def self.remove_join_with_name( name )

    current_join = @@joins.find { |join| join[:name] == name }
    @@joins.delete( current_join ) if current_join != nil
  end

  def self.sql_data_type_for_column( column_name )

    my_class = self.to_s

    @@columns_data = {} if !defined?(@@columns_data)

    if !@@columns_data.has_key?( my_class )
      self.initialize_column_data()
    end

    column_data = @@columns_data[my_class].find do |column_data|
      column_data[:name] == column_name
    end

    if column_data == nil
      raise("Error in #{self}: no data found for column ''#{column_name}'.")
    else
      return column_data[:data_type]
    end

  end

  def self.initialize_column_data()

    my_class = self.to_s
    query_results = QueryInterface.get_table_columns( self::TABLE_NAME )


    @@columns_data[my_class] = query_results.map do |result|
      {
        name: result['column_name'],
        data_type: result['data_type']
      }
    end

  end

end
