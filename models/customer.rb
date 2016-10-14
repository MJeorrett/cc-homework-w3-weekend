require_relative('model')

class Customer < Model

  def initialize( data )
    super( data, 'customers' )
  end

end
