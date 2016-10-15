require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/model_generator/model_generator')

require('pry-byebug')

# CUSTOMERS
Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

Customer.add_many_to_many_join(
  'films',
  Film,
  'customer_id',
  'tickets',
  'film_id',
  'films'
)

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

# FILMS

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


# TICKETS

# make ticket gnerator!!!

customers[0].films

binding.pry
nil
