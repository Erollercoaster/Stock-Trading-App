class Admin::UsersController < Admin::BaseController
    before_action :set_user, only: [:show, :update, :approve, :edit, :destroy]
  
    def index
      @users = User.all
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'User was successfully created.'
      else
        render :new, alert: 'There was a problem creating the user'
      end
    end
  
    def new
      @user = User.new
    end
  
    def show; end
  
    def edit; end
  
    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
      else
        render :edit, alert: 'There was a problem updating the user.'
      end
    end
  
    def destroy
      if @user.destroy
        redirect_to admin_users_path, notice: 'User was successfully deleted.'
      else
        redirect_to admin_users_path, alert: 'There was a problem deleting the user.'
      end
    end
  
    def approve
      if @user.update(approved: true, pending: false)
        redirect_to admin_users_path, notice: 'User has been approved successfully.'
      else
        redirect_to admin_users_path, alert: 'Failed to approve the user.'
      end
    end
  
    def pending
      @users = User.where(pending: true)
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :is_admin, :balance, :approved, :pending)
    end
  end
  