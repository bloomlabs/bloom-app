# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( logo.png )
Rails.application.config.assets.precompile += %w( booking_app.js )
Rails.application.config.assets.precompile += %w( interviewers_app.js )
%w( job_postings booking booking_access_tokens interviewers welcome user_profiles membership_requests membership_payments membership_types users wifi ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js", "#{controller}.css"]
end