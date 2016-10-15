require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

# SET UP RELATIONS
Customer.add_many_to_many_join(
  'films',
  Film,
  'customer_id',
  'tickets',
  'film_id',
  'films'
)

Film.add_many_to_many_join(
  'customers',
  Customer,
  'film_id',
  'tickets',
  'customer_id',
  'customers'
)

# INITIALIZE OBJECTS
customers = Customer.all()
films = Film.all()
tickets = Ticket.all()

binding.pry
nil
