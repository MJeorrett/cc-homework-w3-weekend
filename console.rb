require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

# CUSTOMERS
c_matthew_jeorrett = Customer.new(first_name: "Matthew", last_name: "Jeorrett", funds: 14.57)
c_matthew_jeorrett.save()

# FILMS


# TICKETS


binding.pry
nil
