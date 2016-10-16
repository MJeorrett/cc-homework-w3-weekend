require_relative('rand_generator')
require_relative('constant_generator')

class ModelGenerator

  def initialize(model_class, settings)
    @model_class = model_class
    @settings = settings

    self.set_up_generators()
  end

  def set_up_generators()
    for parameter, settings in @settings

      type = settings[:type]

      case type
      when 'file'
        data_array = ModelGenerator.array_from_file( settings[:path] )
        data_array.shuffle! if settings[:randomise]
        settings[:generator] = data_array

      when 'random_decimal'
        settings[:generator] = RandGenerator.new(:decimal, settings[:min], settings[:max], settings[:precision])

      when 'random_integer'
        settings[:generator] = RandGenerator.new(:integer, settings[:min], settings[:max])

      when 'array'
        settings[:generator] = settings[:data]

      when 'constant'
        settings[:generator] = ConstantGenerator.new( settings[:value] )

      else
        raise(TypeError, "Un-supported source '#{type}'")
      end

    end
  end

  def generate_model()
    parameters = {}

    for parameter, settings in @settings

      if settings[:type] == 'array' && settings[:randomise]
        settings[:generator].shuffle!
      end

      value = settings[:generator].shift()
      parameters[parameter.to_s] = value

      if settings[:duplicates]
        settings[:generator].push(value)
      end
    end

    return @model_class.send(:new, parameters)
  end

  def self.array_from_file( path )
    return File.read(path).lines.map { |line| line.strip }
  end
end
