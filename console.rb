require_relative('models/customer')
require_relative('models/film')

require('pry-byebug')

customers = Customer.all()
films = Film.all()

binding.pry
nil
