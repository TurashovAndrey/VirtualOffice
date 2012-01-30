ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
  :address              => "smtp-15.1gb.ru",
  :port                 => "25",
  # :domain               => 'smtp-15.1gb.ru',
  :user_name            => 'u291566',
  :password             => 'timtimadmin',
  :authentication       => 'plain'}
