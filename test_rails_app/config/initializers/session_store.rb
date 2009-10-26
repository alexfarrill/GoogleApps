# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_rails_app_session',
  :secret      => '2b61469a88aa1aa4a4d737b7ef2f5947b51effae646ed488a7208cf3c3906c1ce269f99b79e5e937f191599af1fdabd262450382076f33ddb66fcdc274b81d79'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
