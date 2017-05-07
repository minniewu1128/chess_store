class ItemsController < ApplicationController

  authorize_resource
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  before_action :check_login, except: [:index, :show, :index_pieces, :index_boards, :index_clocks, :index_supplies]

  def index
    # get info on active items for the big three...
    @all_items = Item.active.all.alphabetical.paginate(:page => params[:page]).per_page(10)
    @boards = Item.active.for_category('boards').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pieces = Item.active.for_category('pieces').alphabetical.paginate(:page => params[:page]).per_page(10)
    @clocks = Item.active.for_category('clocks').alphabetical.paginate(:page => params[:page]).per_page(10)
    @supplies = Item.active.for_category('supplies').alphabetical.paginate(:page => params[:page]).per_page(10)    
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.to_a
    
  end

  def index_boards
    @boards = Item.active.for_category('boards').alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def index_pieces
    @pieces = Item.active.for_category('pieces').alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def index_clocks
    @clocks = Item.active.for_category('clocks').alphabetical.paginate(:page => params[:page]).per_page(10)
  end


  def index_supplies
    @supplies = Item.active.for_category('supplies').alphabetical.paginate(:page => params[:page]).per_page(10)    
  end


  def reorder_list
    @items_to_reorder = Item.need_reorder.alphabetical.to_a
  end



  def show
    # get the price history for this item,should only be seen ny 
    if logged_in? && (current_user.role?(:manager)||current_user.role?(:admin))
      @price_history = @item.item_prices.chronological.to_a
    end
    # everyone sees similar items in the sidebar
    @similar_items = Item.for_category(@item.category).active.alphabetical.to_a - [@item]
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    
    if @item.save
      redirect_to item_path(@item), notice: "Successfully created #{@item.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "Successfully updated #{@item.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "Successfully removed #{@item.name} from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :color, :category, :weight, :inventory_level, :reorder_level, :active, :photo)
  end
  
end