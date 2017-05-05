class OrderItemsController < ApplicationController
    before_action :check_login
    before_action :set_order_item

    def mark_as_shipped
        
        @order_item.shipped
        @orders_to_ship = Order.not_shipped.chronological.to_a

        respond_to do |format|
            format.html{redirect_to home_path, notice: "Successfully shipped order item!"}
            format.js
        end
        
    end

    # before_action :set_order_item, only: [:show, :edit, :update, :destroy]

    # def index
    # end

    # def new
    #     @order_item = OrderItem.new
    # end

    # def create
    #     @order_item = OrderItem.new(order_item_params)
    #     if @order_item.save
    #     else
    #         redirect_to cart_path, notice: "An error occured when placing your order."
    #     end
    # end

    # def update
    # end

    # def destroy
    # end

    # def show
    # end

 private

    def set_order_item
        @order_item = OrderItem.find(params[:id])
    end

    # def order_item_params
    #     params.require(:order_item).permit(:item_id, :quantity, :order_id)
    # end


end
