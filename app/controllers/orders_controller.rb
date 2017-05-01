class OrdersController < ApplicationController
  include ChessStoreHelpers::Cart
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
    @order= Order.new(order_params)
    save_each_item_in_cart(@order)
    @order.grand_total = calculate_cart_items_cost
    if @order.save
      #should I do this before or after saving the order
      redirect_to cart_path, notice: "Order complete!"
    else
      redirect_to cart_path, notice: "An error occured while placing your order."
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
    params.require(:order).permit(:date, :school_id, :user_id, :grand_total, :payment_receipt)
  end



  
end
