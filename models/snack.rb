require_relative('model')

class Snack < Model

  TABLE_NAME = 'snacks'

  def number_of_sales()
    conditions = { id: @id }
    result = QueryInterface.all_where( 'customers_snacks', conditions )
    return result[0]['number_of_sales'].to_i
  end

end
