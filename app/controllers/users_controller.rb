class UsersController < ApplicationController
    
  def index
    @users = User.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  #different when admin is ediitng user and when user is editing themself

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: "Successfully created #{@user.proper_name}."
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
      if current_user && current_user.role?(:admin)
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active)
      else
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :active)
      end
    end
end
