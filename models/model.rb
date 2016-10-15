require_relative('../db/query_interface')

require('pry-byebug')

class Model

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
        raise(TypeError, "Key '#{key}' not a column in table '#{self.table_name()}'.")
      end
    end

  end

  def save()
    id = QueryInterface.insert( table_name(), @data )
    @id = id
  end

  def update()
    QueryInterface.update( table_name(), @data, @id )
  end

  def delete()
    QueryInterface.delete_with_id( table_name(), @id )
  end

  def method_missing(method_sym, *args)
    if method_sym.to_s[-1] == '='
      column = method_sym[0..-2].to_sym
      assign = true
    else
      column = method_sym
      assign = false
    end

    if @data.keys().include?(column)
      if assign
        @data[column] = args[0]
      end

      return @data[column]
    else
      super
    end
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

  def self.table_name()
    raise "Error: 'self.table_name' must be implemented in sub-classes of Model."
  end

end
