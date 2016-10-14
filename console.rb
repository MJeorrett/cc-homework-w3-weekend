require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/model_generator/model_generator')

require('pry-byebug')

# CUSTOMERS
Customer.delete_all()

customer_settings = {
  first_name: {
    type: 'file',
    path: "data/first_names_male.txt",
    randomise: true
  },
  last_name: {
    type: 'file',
    path: "data/last_names.txt",
    randomise: true
  },
  funds: {
    type: 'random_decimal',
    min: 5.00,
    max: 100.00,
    precision: 2
  }
}

customer_generator = ModelGenerator.new( Customer, customer_settings )
customers = []

30.times do
  customer = customer_generator.generate_model()
  customer.save()
  customers.push(customer)
end

# FILMS


# TICKETS


binding.pry
nil
