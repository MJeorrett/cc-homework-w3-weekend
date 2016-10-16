require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/model_generator/model_generator')

require('pry-byebug')

# DELETE EXISTING RECORDS
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


# GENERATE TICKETS
customer_ids = customers.map { |customer| customer.id }
min_customer_id = customer_ids.min()
max_customer_id = customer_ids.max()

film_ids = films.map { |film| film.id }
min_film_id = film_ids.min()
max_film_id = film_ids.max()

ticket_generator_settings = {
  customer_id: {
    type: 'random_integer',
    min: min_customer_id,
    max: max_customer_id
  },
  film_id: {
    type: 'random_integer',
    min: min_film_id,
    max: max_film_id
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
