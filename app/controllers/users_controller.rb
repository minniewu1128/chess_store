class UsersController < ApplicationController
    
  def index
    @users = User.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      #only admin is able to set the roles of users
      if current_user && current_user.role?(:admin)
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active)
      else
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :active)
      end
    end
end
