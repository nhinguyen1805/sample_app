class UsersController < ApplicationController
  before_action :load_user, only: [:show, :edit, :update]
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate page: params[:page],
      :per_page => Settings.users.index.per_page
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user.present?
      flash[:danger] = t ".user_not_found"
      redirect_to signup_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users.check"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    @user = User.find params[:id]
    if @user.update_attributes(user_params)
      flash[:success] = t "controllers.users.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete"
      redirect_to users_url
    else
      flash[:danger] = t "controllers.users.destroy"
      redirect_to @user
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
      redirect_to signup_path
      flash[:info] = t "controllers.users.no_user"
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controllers.users.danger"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    if current_user?(@user)
      redirect_to(root_url)
    else
      render :new
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
