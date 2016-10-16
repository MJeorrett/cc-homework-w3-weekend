require_relative('model')
require_relative('../db/query_interface')

class Customer < Model

  TABLE_NAME = 'customers'

  def initialize( data )
    super( data )
  end

  def number_of_tickets()
    conditions = { id: @id }
    result = QueryInterface.all_where( 'customers_vw', conditions )
    return result[0]['number_of_tickets'].to_i
  end

end
