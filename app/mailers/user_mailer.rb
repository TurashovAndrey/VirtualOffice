# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "admin@timtim.ru"

  def welcome_email(user)
    @user = user
    @url  = activate_user_account_url(user.perishable_token)
    mail(:to => user.email,:subject => "Добро пожаловать на TimTim.ru")
  end

end
