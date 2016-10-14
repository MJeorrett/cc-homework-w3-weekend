require('pry-byebug')

class RandGenerator

  def initialize( type, min, max, precision )
    @type = type
    @min = min
    @max = max
    @precision = precision
    @delta = max - min
  end

  def shift()
    next_number = (rand() * @delta) + @min

    case @type
    when :decimal
      return next_number.round(@precision)
    when :integer
      return next_number.round(0).to_i
    else
      raise(TypeError, "Un-supported type parameter: #{@type}.")
    end
  end

end
