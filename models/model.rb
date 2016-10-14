require_relative('../db/query_builder')

require('pry-byebug')

class Model

  def initialize( data )

    if data['id'] != nil
      @id = data['id']
      data.delete('id')
    end

    @data = data
  end

  def update_data( column, new_value=nil )
    if new_value != nil
      @data[column] = new_value
    end
    return @data[column]
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
