require_relative('models/ticket')

class Cinema

def self.sell_ticket( customer, film )

  if customer.funds < film.price

    raise "Error: customer can't afford ticket!"
  else

    ticket_data = {
      'customer_id' => customer.id,
      'film_id' => film.id
    }

    ticket = Ticket.new( ticket_data )
    ticket.save

    customer.funds -= film.price
    customer.update
  end
end

end
