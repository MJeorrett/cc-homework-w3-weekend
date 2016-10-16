require_relative('model')

class Film < Model

  TABLE_NAME = 'films'

  def initialize( data )
    super( data )
  end

end
