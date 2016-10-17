require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/snack')
require_relative('cinema')

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

Customer.add_one_to_many_join(
  'tickets',
  Ticket,
  'customer_id',
  'tickets'
)

Customer.add_many_to_many_join(
  'snacks',
  Snack,
  'customer_id',
  'customers_snacks',
  'snack_id',
  'snacks'
)

Film.add_many_to_many_join(
  'customers',
  Customer,
  'film_id',
  'tickets',
  'customer_id',
  'customers'
)

Film.add_one_to_many_join(
  'tickets',
  Ticket,
  'film_id',
  'tickets'
)

Snack.add_many_to_many_join(
  'customers',
  Customer,
  'snack_id',
  'customers_snacks',
  'customer_id',
  'customers'
)

binding.pry
nil
