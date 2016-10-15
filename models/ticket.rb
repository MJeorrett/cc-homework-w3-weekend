require_relative('model')

class Ticket < Model

  def initialize( data )
    super( data )
  end

  def self.table_name
    return 'tickets'
  end

end
