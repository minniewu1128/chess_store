class OrdersController < ApplicationController
  include ChessStoreHelpers::Cart
  include ChessStoreHelpers::Shipping
  before_action :check_login
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  #is it possible to edit orders?

  #add to cart, remove from cart methods with routes

  def index
    @orders = Order.all.chronological.to_a
    #for shippers
    @unshipped_orders = Order.not_shipped.chronological.to_a
    @paid_and_unshipped_orders = Order.paid.not_shipped.chronological.to_a
  end

  def show
    @total_weight = @order.total_weight
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    #order created when pressing "Place Order" button in shopping cart
    #user can see what they're going to buy, choose school, add credit card number
    orderh = params[:order]
    if !orderh[:school_id].nil? && !orderh[:school_id].blank? #(check not nil, if they select from dropdown)
       puts "new school"
      @relevant_school_id = orderh[:school_id]
    else #(create a new school if they don't select one)
     
      @school = School.new(name: orderh[:school_name], zip: orderh[:school_zip], street_1: orderh[:school_street_1], street_2: orderh[:school_street_2], city: orderh[:school_city], state: orderh[:school_state])
      if @school.save!
          @relevant_school_id = @school.id
      else
         return render "checkout", notice: "Please make sure school information is filled out correctly."
      end
    end
    
    @order= Order.new(user_id: current_user.id, school_id: @relevant_school_id, credit_card_number: orderh[:credit_card_number], expiration_year: orderh[:expiration_year].to_i, expiration_month: orderh[:expiration_month].to_i)
    @order.grand_total = calculate_cart_items_cost + calculate_cart_shipping
    if @order.save!
      #should I do this before or after saving the order
      @order.pay
      save_each_item_in_cart(@order)
      destroy_cart
      create_cart
      return redirect_to cart_path, notice: "Order complete!"
    else
      return render 'checkout', notice: "An error occured while placing your order."
    end
  end


  def update
  end

  def destroy
  end

  def add_to_cart
    quantity = Integer(params[:add_to_cart][:quantity])

    quantity.times do 
      add_item_to_cart(params[:add_to_cart][:item_id])
    end

    redirect_to cart_path
    #pass in item_id as parameter (try to do this with ajax)
  end

  def remove_from_cart
    #see if you can change number of items in cart
    item_id = params[:remove_from_cart][:item_id]
    remove_item_from_cart(item_id)

    redirect_to cart_path
  end

 

  def cart
    @list = get_list_of_items_in_cart
    @cost = calculate_cart_items_cost
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end


  def order_params
    params.require(:order).permit(:school_id, :user_id, :school_name, :school_zip, :school_street_1, :school_street_2, :school_city, :school_state, :credit_card)
  end



  
end
