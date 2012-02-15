#ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.perform_deliveries = true

#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp-15.1gb.ru",
#  :port                 => "25",
  # :domain               => 'smtp-15.1gb.ru',
  # :user_name            => 'u291566',
#  :user_name            => 'admin@timtim.ru',
#  :password             => 'timtimadmin',
#  :authentication       => 'plain'}

 ActionMailer::Base.smtp_settings = {
   :address  => 'mail.1gb.ru',
   :port=>25,
   :domain => 'timtim.ru',
   :user_name  => 'u293228',
   :password  => '44f1dbcb',
   :authentication  => :login
 }
 ActionMailer::Base.delivery_method = :smtp
 ActionMailer::Base.raise_delivery_errors = true
 ActionMailer::Base.perform_deliveries = true


