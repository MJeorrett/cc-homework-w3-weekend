require_relative('../db/query_builder')

class Model

  def initialize( data )

    if data['id'] != nil
      @id = data['id']
      data.delete('id')
    end

    @data = data
  end

  def save()
    id = QueryBuilder.insert( @table_name, @data )
    @id = id
  end

end
