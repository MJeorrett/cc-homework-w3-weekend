require_relative('model')

class Customer < Model

  def initialize( data )
    super( data )
  end

  def self.table_name
    return 'customers'
  end

end
