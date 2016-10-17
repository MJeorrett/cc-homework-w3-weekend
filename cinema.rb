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
      ticket.save()

      customer.funds -= film.price
      customer.update()
    end
  end

  def self.sell_snack( customer, snack )
    if customer.funds < snack.price
      raise "Error: customer can't afford snack!"
    else
      customer_snack_data = {
        'customer_id' => customer.id,
        'snack_id' => snack.id
      }

      customer_snack = CustomerSnack.new( customer_snack_data )
      customer_snack.save()

      customer.funds -= snack.price
      customer.update()
    end
  end

end
