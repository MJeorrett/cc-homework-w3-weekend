require_relative('model')

class Film < Model

  def initialize( data )
    super( data )
  end

  def self.table_name
    return 'films'
  end

end
