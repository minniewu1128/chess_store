class HomeController < ApplicationController
# customer homepage shoudl have previously purchased items
  def home
    @home = true
    if logged_in?
        if current_user.role? :manager
            @items_to_reorder = Item.need_reorder.alphabetical.to_a
        elsif current_user.role? :shipper
            @orders_to_ship = Order.not_shipped.chronological.to_a


        end
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
end