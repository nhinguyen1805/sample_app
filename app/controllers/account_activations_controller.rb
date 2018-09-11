class AccountActivationsController < ApplicationController
  before_action :load_user, only:[:edit]

  def edit
    if @user.activate
      log_in @user
      flash[:success] = t "controllers.account.activated"
      redirect_to @user
    else
      flash[:danger] = t "controllers.account.invalid"
      redirect_to root_url
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    redirect_to root_path
    flash[:info] = t " controllers.users.no_user"
  end
end
