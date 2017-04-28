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
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def add_to_cart
    add_item_to_cart(params[:item_id])
    redirect_to home_path
    #pass in item_id as parameter (try to do this with ajax)
  end

  def remove_from_cart
  end

  private

  def set_order
    @order = Order.find(params[:id])

  end

  def order_params
    params.require(:order).permit(:date, :school_id, :user_id, :grand_total, :payment_receipt)
  end



  
end
