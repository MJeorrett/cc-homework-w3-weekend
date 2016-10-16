require_relative('model')

class Film < Model

  TABLE_NAME = 'films'

  def initialize( data )
    super( data )
  end

  def number_of_tickets()
    conditions = { id: @id }
    result = QueryInterface.all_where( 'films_vw', conditions )
    return result[0]['number_of_tickets'].to_i
  end

end
