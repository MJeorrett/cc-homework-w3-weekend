require_relative('model')

class Ticket < Model

  TABLE_NAME = 'tickets'

  def initialize( data )
    super( data )
  end

end
