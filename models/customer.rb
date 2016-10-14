require_relative('model')

class Customer < Model

  def initialize( data )
    super( data )
    @table_name = 'customers'
  end

end
