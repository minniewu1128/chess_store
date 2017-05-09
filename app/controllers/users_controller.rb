class UsersController < ApplicationController


  before_action :check_login, except: [:new, :create]
  authorize_resource
    
  def index
    @active_users = User.active.alphabetical.paginate(:page => params[:page]).per_page(20)
    @active_employees = User.employees.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @active_customers = User.cusstomers.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_users = User.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_employees = User.employees.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = User.customers.inactive.alphabetical.paginate(:page=>params[:page]).per_page(10)
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def show
    @user = current_user
  end

  def user_all_orders
    @orders = current_user.orders.chronological
    @unshipped = current_user.orders.not_shipped.chronological
  end

  #different when admin is editng user and when user is editing themself

  def create
    @user = User.new(user_params)
    
    if !logged_in? || (!current_user.role?(:admin) && !current_user.role?(:manager))
      @user.role = 'customer'
    end
    
    if @user.save 
      if !logged_in? || (!current_user.role?(:admin) && !current_user.role?(:manager))
        session[:user_id] = @user.id
        redirect_to home_path, notice: "#{@user.first_name}, you have now signed up as #{@user.username}."
      else
        redirect_to home_path, notice: "Successfully added new user: #{@user.username}."
      end
    else
      render action: 'new' 
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Successfully updated #{@user.username}."
    else
      render action: 'edit'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      #only admin is able to set the roles of users
      if current_user && (current_user.role?(:admin) || current_user.role?(:manager))
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active)
      else
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :active)
      end
    end
end
