class GoogleCalendar
  attr_accessor :id, :title, :event_feed_url, :updated
  
  def initialize(entry)
    self.id = entry["id"]
    self.event_feed_url = entry["link"].detect{ |e| e["rel"] == "alternate" }["href"]
    self.title = entry["title"]
    self.updated = entry["updated"]
  end
  
  def create_event!( opts = {} )
    token = GoogleApps::CalendarsConnection.new.token
    headers = token

    body = String.new
    builder = Builder::XmlMarkup.new(:indent => 2, :target => body)
    builder.entry(:xmlns => "http://www.w3.org/2005/Atom", "xmlns:gd" => "http://schemas.google.com/g/2005") do |entry|
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

    response = HTTParty.post event_feed_url, :headers => headers, :body => body, :query => {}
    doc = Crack::XML.parse(response)
    GoogleCalendarEvent.new doc["entry"]
  end
  
  def events
    token = GoogleApps::CalendarsConnection.new.token
    headers = token
    
    response = HTTParty.get event_feed_url, :headers => headers, :body => "", :query => {}
    
    if response.code / 100 == 2
      # return an array of GoogleCalendarEvent's
      doc = Crack::XML.parse(response)
      Array(doc["feed"]["entry"]).collect do |entry|
        GoogleCalendarEvent.new entry
      end
    else
      raise GoogleAppsError, response
    end
  end
  
  def self.ical_recurrence_string(opts)
    # http://www.ietf.org/rfc/rfc2445.txt
    # input:
    # { :starts_at => Time.mktime(2007,5,1,11), 
    #   :ends_at => Time.mktime(2007,5,1,12), 
    #   :rrule => { :freq => :weekly, :byday => :tu, :until => Time.mktime(2007,9,4) } }
    #
    # output:
    # DTSTART;VALUE=DATE:20070501
    # DTEND;VALUE=DATE:20070502
    # RRULE:FREQ=WEEKLY;BYDAY=TU;UNTIL=20070904
    
    ary = opts.collect do |k,v|
      if v.is_a?(Hash)
        "#{k}:#{v.map{|a,b| "#{a}=#{ b.is_a?(Time) ? b.to_s(:ical) + "Z" : b }"}.join(';')}"
      elsif v.is_a?(Time)
        "#{k};VALUE=DATE-TIME:#{v.to_s(:ical)}"
      elsif v.is_a?(Date)
        "#{k};VALUE=DATE:#{v.to_s(:ical)}"
      else
        raise ArgumentError, "Unsupported datatype for '#{k}' for ical in hash: #{opts.inspect}"
      end
    end
    
    str = ary.map(&:upcase).join("\r\n")
  end
end