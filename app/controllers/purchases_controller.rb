class PurchasesController < ApplicationController
  before_action :check_login
  authorize_resource #check ability file

  def index
    @purchases = Purchase.chronological.paginate(:page => params[:page]).per_page(20)
  end

  def new
    @purchase = Purchase.new
  end



  def create
    
    @purchase = Purchase.new(purchase_params)
    @purchase.date = Date.current
    respond_to do |format|
      if @purchase.save
        format.html {redirect_to home_path, notice: "Successfully added a purchase for #{@purchase.quantity} #{@purchase.item.name}."}
        @items_to_reorder = Item.need_reorder.alphabetical.to_a
        format.js
      else
        format.html {render action: 'new'}
      end
    end
  end

  private
  def purchase_params
    params.require(:purchase).permit(:item_id, :quantity)
  end
  
end

#question: how to redirect to whereever you came from