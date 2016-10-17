require_relative('models/customer')
require_relative('models/film')
require_relative('models/snack')
require_relative('models/ticket')
require_relative('models/customer_snack')
require_relative('models/model_generator/model_generator')

require('pry-byebug')

# DELETE EXISTING RECORDS
CustomerSnack.delete_all()
Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

# GENERATE CUSTOMERS
customer_generator_settings = {
  first_name: {
    type: 'file',
    path: "data/first_names_male.txt",
    randomise: true,
    duplicates: false
  },
  last_name: {
    type: 'file',
    path: "data/last_names.txt",
    randomise: true,
    duplicates: false
  },
  funds: {
    type: 'random_decimal',
    min: 5.00,
    max: 100.00,
    precision: 2
  }
}

customer_generator = ModelGenerator.new( Customer, customer_generator_settings )
customers = []

30.times do
  customer = customer_generator.generate_model()
  customer.save()
  customers.push(customer)
end

# GENERATE FILMS
film_generator_settings = {
  title: {
    type: 'file',
    path: 'data/film_names.txt',
    randomise: true,
    duplicates: false
  },
  price: {
    type: 'array',
    data: [7.50, 9.50, 12.00],
    randomise: true,
    duplicates: true
  }
}

film_generator = ModelGenerator.new( Film, film_generator_settings)
films = []

20.times do
  film = film_generator.generate_model()
  film.save()
  films.push(film)
end

# GENERATE SNACKs
snacks_values = [
  ['Mars Bar', 0.99],
  ['Yorkie', 0.99],
  ['Crisps', 1.10],
  ['Coke', 2.10],
  ['Popcorn', 3.50],
  ['Hotdog', 5.00],
]
snacks_keys = [
  'name',
  'price'
]
snacks = ModelGenerator.models_from_keys_and_values(
  Snack,
  snacks_keys,
  snacks_values )

# GENERATE TICKETS
customer_ids = customers.map { |customer| customer.id }
film_ids = films.map { |film| film.id }

ticket_generator_settings = {
  customer_id: {
      type: 'array',
      data: customer_ids,
      randomise: true,
      duplicates: true
  },
  film_id: {
    type: 'array',
    data: film_ids,
    randomise: true,
    duplicates: true
  },
  used: {
    type: 'random_boolean'
  }
}

ticket_generator = ModelGenerator.new( Ticket, ticket_generator_settings )
tickets = []
30.times do
  ticket = ticket_generator.generate_model()
  ticket.save()
  tickets.push(ticket)
end

# GENERATE CUSTOMER SNACKS
snack_ids = snacks.map { |snack| snack.id }

customer_snack_generator_settings = {
  customer_id: {
      type: 'array',
      data: customer_ids,
      randomise: true,
      duplicates: true
  },
  snack_id: {
    type: 'array',
    data: snack_ids,
    randomise: true,
    duplicates: true
  }
}

customer_snack_generator = ModelGenerator.new( CustomerSnack, customer_snack_generator_settings )
customers_snacks = []
30.times do
  customer_snack = customer_snack_generator.generate_model()
  customer_snack.save()
  customers_snacks.push( customer_snack )
end
