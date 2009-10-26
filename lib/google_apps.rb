class GoogleApps
  include HTTParty
  @@config = YAML::load(File.read(File.join(Rails.root, "config", "google_apps.yml")))
  
  def auth(service)
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
    
    response = self.class.post "https://www.google.com/accounts/ClientLogin",
      :query => {
        :accountType => "HOSTED_OR_GOOGLE", 
        :Email => @@config[Rails.env]["email"], 
        :Passwd => @@config[Rails.env]["password"], 
        :service => service.to_s
      }

    if response.code / 100 == 2
      { "Authorization" => "GoogleLogin #{response.split("\n")[2]}" }
    else
      raise response.inspect
    end
    
  end
  
  # def spreadsheets( refresh = false )
  # need to authenticate against wise
  #   return @spreadsheets if !refresh && @spreadsheets
  #   default_headers = { "GData-Version" => "3.0" }
  #   default_headers.merge!("If-None-Match" => @spreadsheets_etag) if @spreadsheets_etag
  #   resp = self.class.get "http://spreadsheets.google.com/feeds/spreadsheets/private/full", :headers => default_headers.merge(@auth)
  #   
  #   if resp.code == 200
  #     doc = Hpricot.XML(resp)
  #     @spreadsheets_etag = resp.headers["etag"].first
  # 
  #     @spreadsheets = []
  #     (doc/"entry").each do |d|
  #       g = GoogleApps::GoogleSpreadsheet.new :id => (d/"id").inner_html, :updated => (d/"updated").inner_html, :title => (d/"title").inner_html
  #       @spreadsheets << g
  #     end
  #   
  #     @spreadsheets
  #   else
  #     raise resp.inspect
  #   end
  # end
  
  class SpreadsheetsConnection < GoogleApps
    attr_reader :token

    def initialize
      @token = auth(:writely).merge( "GData-Version" => "2.0", "Content-Type" => "application/atom+xml" )
    end
    
    def create!( opts = {} )
      # sub document for spreadsheet if you want to create a document
      headers = @token
      body = String.new
      builder = Builder::XmlMarkup.new(:indent => 2, :target => body)
      builder.instruct!
      builder.tag! "atom:entry", "xmlns:atom" => "http://www.w3.org/2005/Atom", "xmlns:docs" => "http://schemas.google.com/docs/2007" do |atom_entry|
        atom_entry.tag! "atom:category", :label => "spreadsheet", :term => "http://schemas.google.com/docs/2007#spreadsheet", :scheme => "http://schemas.google.com/g/2005#kind"
        atom_entry.tag! "atom:title", opts[:title] || "new spreadsheet"
        atom_entry.tag! "docs:writersCanInvite", :value => false
      end
    
      response = self.class.post "http://docs.google.com/feeds/documents/private/full", :headers => headers, :body => body, :query => {}
    
      if response.code / 100 == 2
        GoogleSpreadsheet.new response
      else
        raise response.inspect
      end
    end
  
    def add_user(doc, emails, role)
      headers = @token
    
      Array(emails).each do |email|
        body = String.new
        builder = Builder::XmlMarkup.new(:indent => 2, :target => body)
        builder.entry(:xmlns => "http://www.w3.org/2005/Atom", "xmlns:gAcl" => "http://schemas.google.com/acl/2007") do |entry|
          entry.category :scheme => "http://schemas.google.com/g/2005#kind", :term => "http://schemas.google.com/acl/2007#accessRule"
          entry.tag! "gAcl:role", :value => role.to_s
          entry.tag! "gAcl:scope", :type => "user", :value => email
        end
      
        response = self.class.post "http://docs.google.com/feeds/acl/private/full/document%3A#{ doc.document_id }", :headers => headers, :body => body, :query => {}
      end
    end
  end
  
  class CalendarsConnection < GoogleApps
    attr_reader :token

    def initialize
      @token = auth(:cl).merge( "GData-Version" => "2.0", "Content-Type" => "application/atom+xml" )
    end

    def list
      headers = @token
      response = self.class.get "http://www.google.com/calendar/feeds/default/owncalendars/full", :headers => headers, :body => "", :query => {}
    end
    
    def calendars
      Array(GoogleCalendar.new(list))
    end
    
    def create_event!( opts = {} )
      headers = @token
      body = String.new
      builder = Builder::XmlMarkup.new(:indent => 2, :target => body)
      builder.entry(:xmlns => "http://www.w3.org/2005/Atom", "xmlns:gd" => "http://schemas.google.com/g/2005") do |entry|
        entry.category :scheme => "http://schemas.google.com/g/2005#kind", :term => "http://schemas.google.com/g/2005#event"
        entry.title opts[:title], :type => "text"
        entry.content opts[:description], :type => "text"
        entry.tag! "gd:where", :valueString => opts[:location]
        entry.tag! "gd:when", :startTime => opts[:starts_at].utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"), 
          :endTime => opts[:ends_at].utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
      end
      
      response = self.class.post "http://www.google.com/calendar/feeds/default/private/full", :headers => headers, :body => body, :query => {}
      doc = Crack::XML.parse(response)
      GoogleCalendarEvent.new doc["entry"]
    end
  end
  
end

class GoogleSpreadsheet
  attr_accessor :document_id, :title, :link, :updated
  
  def initialize( response )
    doc = Crack::XML.parse(response)
    self.document_id = doc["entry"]["gd:resourceId"].split(":").last
    self.link = doc["entry"]["link"].detect{ |e| e["rel"] == "alternate" }["href"]
    self.title = doc["entry"]["title"]
    self.updated = doc["entry"]["updated"]
  end
end

class GoogleCalendar
  attr_accessor :id, :title, :event_feed_url, :updated
  
  def initialize( response )
    doc = Crack::XML.parse(response)
    feed = doc["feed"]
    self.id = feed["entry"]["id"]
    self.event_feed_url = feed["entry"]["link"].detect{ |e| e["rel"] == "alternate" }["href"]
    self.title = feed["entry"]["title"]
    self.updated = feed["entry"]["updated"]
  end
  
  def events
    token = GoogleApps::CalendarsConnection.new.token
    headers = token
    response = HTTParty.get event_feed_url, :headers => headers, :body => "", :query => {}
    
    if response.code / 100 == 2
      # return an array of GoogleCalendarEvent's
      doc = Crack::XML.parse(response)
      doc["feed"]["entry"].collect do |entry|
        GoogleCalendarEvent.new entry
      end
    else
      raise response.inspect
    end
    
  end
end

# An event in a calendar
class GoogleCalendarEvent
  attr_accessor :etag, :starts_at, :ends_at, :title, :edit_url
  def initialize(entry)
    if entry["id"]
      self.etag = entry["gd:etag"].gsub(/&[^;]+;/, '')
      self.starts_at = entry["gd:when"]["startTime"]
      self.ends_at = entry["gd:when"]["endTime"]
      self.title = entry["title"]
      self.edit_url = entry["link"].detect{ |e| e["rel"] == "edit" }["href"]
    else
      entry.each{ |k,v| self.send("#{k}=", v) }
    end
  end
  
  def update!(opts = {}, force = true)
    # etags code needs work, not working
    token = GoogleApps::CalendarsConnection.new.token
    headers = force ? token.merge("If-Match" => "*") : token.merge("If-Match" => self.etag)
    
    body = String.new
    builder = Builder::XmlMarkup.new(:indent => 2, :target => body)
    builder.entry(:xmlns => "http://www.w3.org/2005/Atom", "xmlns:gd" => "http://schemas.google.com/g/2005", "xmlns:gCal" => "http://schemas.google.com/gCal/2005") do |entry|
      entry.id edit_url
      # from create_event:
      entry.category :scheme => "http://schemas.google.com/g/2005#kind", :term => "http://schemas.google.com/g/2005#event"
      entry.title opts[:title], :type => "text"
      entry.content opts[:description], :type => "text"
      entry.tag! "gd:where", :valueString => opts[:location]
      entry.tag! "gd:when", :startTime => opts[:starts_at].utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"), 
        :endTime => opts[:ends_at].utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    end
    
    response = HTTParty.put edit_url, :headers => headers, :body => body, :query => {}    
    if response.code / 100 == 2
      # return a GoogleCalendarEvent
      doc = Crack::XML.parse(response)
      GoogleCalendarEvent.new doc["entry"]
    else
      raise response.inspect
    end
  end
  
  def destroy(force = true)
    # etags code needs work, not working
    token = GoogleApps::CalendarsConnection.new.token
    headers = force ? token.merge("If-Match" => "*") : token.merge("If-Match" => self.etag)
    HTTParty.delete edit_url, :headers => headers, :body => "", :query => {}
  end
end