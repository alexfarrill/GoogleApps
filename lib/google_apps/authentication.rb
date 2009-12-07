class GoogleApps
  include HTTParty
  @@config = YAML::load(File.read(File.join(Rails.root, "config", "google_apps.yml")))
  
  # GOOGLE API SERVICES:
  # Google API  Service name
  # Google Analytics Data APIs  analytics
  # Google Apps Provisioning APIs apps
  # Google Base Data API  gbase
  # Blogger Data API  blogger
  # Book Search Data API  print
  # Calendar Data API cl
  # Google Code Search Data API codesearch
  # Contacts Data API cp
  # Documents List Data API writely
  # Finance Data API  finance
  # Gmail Atom feed mail
  # Health Data API health
  # weaver (H9 sandbox)
  # Maps Data APIs  local
  # Notebook Data API notebook
  # Picasa Web Albums Data API  lh2
  # Spreadsheets Data API wise
  # Webmaster Tools API sitemaps
  # YouTube Data API  youtube
  @@services = { :calendars => "cl", :documents => "writely", :spreadsheets => "wise" }
  
  def auth(service)
    response = self.class.post "https://www.google.com/accounts/ClientLogin",
      :query => {
        :accountType => "HOSTED_OR_GOOGLE", 
        :Email => @@config[Rails.env]["email"], 
        :Passwd => @@config[Rails.env]["password"], 
        :service => @@services[service] || service.to_s
      }

    if response.code / 100 == 2
      { "Authorization" => "GoogleLogin #{response.split("\n")[2]}" }
    else
      raise GoogleAppsError::AuthorizationFailed, response
    end
  
  end
  
end