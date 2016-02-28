# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# SendGrid email config
ActionMailer::Base.smtp_settings = {
    address:          'smtp.sendgrid.net',
    port:             587,
    authentication:   :plain,
    user_name:        ENV['SENDGRID_USERNAME'],
    password:         ENV['SENDGRID_PASSWORD'],
    domain:           'memberships.bloom.org.au',
    enable_starttls_auto: true
}

ActionMailer::Base.delivery_method = :smtp
