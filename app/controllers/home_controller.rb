class HomeController < ApplicationController
# customer homepage shoudl have previously purchased items
  def home
    @home = true

    active_items = Item.active.all.alphabetical.to_a
    active_item_count = active_items.map do |i|
    count = 0
      i.order_items.all.each do |oi|
        count += oi.quantity
      end
        [i, count]
     end

     popular_sorted = active_item_count.sort_by{|k| k[1]}
     @popular_limited = popular_sorted.reverse 
             
    if logged_in?
        if current_user.role? :manager
            @items_to_reorder = Item.need_reorder.alphabetical.to_a
        elsif current_user.role? :shipper
            @orders_to_ship = Order.not_shipped.chronological.to_a

        elsif current_user.role?(:admin)
            @customers = User.customers.all.alphabetical.to_a
            @total_spent = @customers.map do |u|
              sum = 0
              u.orders.all.each do |o|
                sum += o.grand_total
              end
              [u.username, sum]         
            end

            spenders = @total_spent.sort_by{|k| k[1]}
            top_spenders = spenders.last(5)
            @spender_names = top_spenders.map{|k| k[0]}
            @spender_totals = top_spenders.map{|k| k[1] }





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