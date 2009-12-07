class GoogleApps
class CalendarsConnection < GoogleApps
  attr_reader :token

  def initialize
    @token = auth(:calendars).merge( "GData-Version" => "2.0", "Content-Type" => "application/atom+xml" )
  end

  def list
    headers = @token
    self.class.get "http://www.google.com/calendar/feeds/default/allcalendars/full", :headers => headers, :body => "", :query => {}
  end
  
  def calendars
    doc = Crack::XML.parse(list.body)
    Array(doc["feed"]["entry"]).collect do |entry|
      GoogleCalendar.new(entry)
    end
  end
  
  def create_event!( opts = {} )
    calendars.first.create_event! opts
  end
end
end