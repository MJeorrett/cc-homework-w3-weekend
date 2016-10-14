require_relative('../db/query_builder')

require('pry-byebug')

class Model

  def initialize( data, table_name )

    @table_name = table_name
    @data = data

    self.check_data_matches_columns()

    if data['id'] != nil
      @id = data['id']
      data.delete('id')
    end
  end

  def check_data_matches_columns()
    query_result = QueryBuilder.get_table_columns( @table_name )
    column_names = query_result.map { |result| result['column_name'] }
    @data.each_key do |key|
      if !column_names.include?(key.to_s)
        raise(TypeError, "Key '#{key}' not a column in table '#{@table_name}'.")
      end
    end
  end

  def save()
    id = QueryBuilder.insert( @table_name, @data )
    @id = id
  end

  def update()
    QueryBuilder.update( @table_name, @data, @id )
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

end
