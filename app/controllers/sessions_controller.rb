class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by(email: params[:session] [:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash.now[:success] = t("session.new.congratulation")
    else
      flash.now[:danger] = t("sessions.new.invalid")
      render "new"
    end
  end

  def destroy; end

end
