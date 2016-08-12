Rails.configuration.google_calendar = {
    :refresh_token => ENV['GOOGLE_CALENDAR_REFRESH_TOKEN'.freeze],
    :project_id => ENV['GOOGLE_CALENDAR_PROJECT_ID'.freeze],
    :client_id => ENV['GOOGLE_CALENDAR_CLIENT_ID'.freeze],
    :client_secret => ENV['GOOGLE_CALENDAR_CLIENT_SECRET'.freeze]
}
require 'google/api_client'
require 'json'
%w{
hash = {:web => {
    :auth_uri => 'https://accounts.google.com/o/oauth2/auth',
    :token_uri => 'https://accounts.google.com/o/oauth2/token',
    :auth_provider_x509_cert_url => 'https://www.googleapis.com/oauth2/v1/certs',
    :redirect_uris => %w(http://localhost:3000/booking/oauth),
    :javascript_origins => %w(http://localhost https://bloom.org.au http://bloom.org.au),
    :project_id => Rails.configuration.google_calendar[:project_id],
    :client_id => Rails.configuration.google_calendar[:client_id],
    :client_secret => Rails.configuration.google_calendar[:client_secret]
}}
secrets_file = Tempfile.new('client_secrets')
secrets_file.write(hash.to_json)
secrets_file.rewind
client_secrets = Google::APIClient::ClientSecrets.load(secrets_file.path)
secrets_file.close
secrets_file.unlink
auth_client = client_secrets.to_authorization
auth_client.update!(
    :scope => 'https://www.googleapis.com/auth/calendar',
    :access_type => 'offline',
    :approval_prompt => 'force',
    :redirect_uri => 'http://localhost:3000/booking/oauth'
)

auth_client.refresh_token = Rails.configuration.google_calendar[:refresh_token]
auth_client.fetch_access_token!
Rails.configuration.google_calendar[:auth_client] = auth_client}