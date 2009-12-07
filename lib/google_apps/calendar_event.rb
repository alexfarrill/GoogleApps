class GoogleCalendarEvent
  attr_accessor :etag, :starts_at, :ends_at, :title, :edit_url, :raw_response
  def initialize(entry)
    if entry["id"]
      self.raw_response = entry
      self.etag = entry["gd:etag"].gsub(/&[^;]+;/, '')
      if entry["gd:when"]
        # non-recurring event
        self.starts_at = entry["gd:when"]["startTime"]
        self.ends_at = entry["gd:when"]["endTime"]
      else
        # recurring event
        # NOT IMPLEMENTED: NEED TO PARSE entry["gd:recurrence"] 
      end
      self.title = entry["title"]
      self.edit_url = entry["link"].detect{ |e| e["rel"] == "edit" }["href"]
    else
      entry.each{ |k,v| self.send("#{k}=", v) }
    end
  end
  
  def update!(opts = {}, force = true)
    # etags code needs work, not implemented
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
      
      if opts[:recurrence]
        # recurs
        ical_opts = { :dtstart => opts[:starts_at], :dtend => opts[:ends_at], :rrule => opts[:recurrence] }
        entry.tag! "gd:recurrence", GoogleCalendar::ical_recurrence_string(ical_opts)
      else
        # doesn't recur
        entry.tag! "gd:when", :startTime => opts[:starts_at].utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"), 
          :endTime => opts[:ends_at].utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
      end
    end
    
    response = HTTParty.put edit_url, :headers => headers, :body => body, :query => {}    
    if response.code / 100 == 2
      # return a GoogleCalendarEvent
      doc = Crack::XML.parse(response)
      GoogleCalendarEvent.new doc["entry"]
    elsif response.match(/No events found/)
      raise GoogleAppsError::NotFound, response
    else
      raise GoogleAppsError, response
    end
  end
  
  def destroy(force = true)
    # etags code needs work, not implemented
    token = GoogleApps::CalendarsConnection.new.token
    headers = force ? token.merge("If-Match" => "*") : token.merge("If-Match" => self.etag)
    HTTParty.delete edit_url, :headers => headers, :body => "", :query => {}
  end
end