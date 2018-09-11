class UserMailer < ApplicationMailer

  def account_activation user
    @user = user
    mail to: user.email, subject: t("user_mailer.subject1")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("user_mailer.subject2")
  end
end
