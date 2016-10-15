class Cinema

 def sell_ticket( customer, film )
   if customer.funds < film.price
     raise "Error: customer can't afford ticket!"
   else
     customer.funds -= film.price
     customer.save
   end
 end

end
