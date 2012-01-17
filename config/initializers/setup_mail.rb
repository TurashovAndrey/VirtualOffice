ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mail.ru",
  :port                 => "25",
  :domain               => 'smtp.mail.ru',
  :user_name            => 'turashov@mail.ru',
  :password             => '17Iverson87',
  :authentication       => 'plain'}
