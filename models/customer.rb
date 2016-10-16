require_relative('model')

class Customer < Model

  TABLE_NAME = 'customers'

  def initialize( data )
    super( data )
  end

end
