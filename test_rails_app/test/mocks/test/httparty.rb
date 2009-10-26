module HTTParty
  module ClassMethods
    def get(path, options={})
      case path
      when "http://www.google.com/calendar/feeds/default/owncalendars/full"
        # 2 calendars
        Response.new "<?xml version='1.0' encoding='UTF-8'?><feed xmlns='http://www.w3.org/2005/Atom' xmlns:openSearch='http://a9.com/-/spec/opensearch/1.1/' xmlns:gCal='http://schemas.google.com/gCal/2005' xmlns:gd='http://schemas.google.com/g/2005' gd:etag='W/&quot;D0IGRnszeip7I2A9WxNVFU8.&quot;'><id>http://www.google.com/calendar/feeds/default/owncalendars/full</id><updated>2009-10-26T02:52:07.582Z</updated><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/gCal/2005#calendarmeta'/><title>alex@example.com's Calendar List</title><link rel='alternate' type='text/html' href='http://www.google.com/calendar/render'/><link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='http://www.google.com/calendar/feeds/default/owncalendars/full'/><link rel='http://schemas.google.com/g/2005#post' type='application/atom+xml' href='http://www.google.com/calendar/feeds/default/owncalendars/full'/><link rel='self' type='application/atom+xml' href='http://www.google.com/calendar/feeds/default/owncalendars/full'/><author><name>alex@example.com</name><email>alex@example.com</email></author><generator version='1.0' uri='http://www.google.com/calendar'>Google Calendar</generator><openSearch:startIndex>1</openSearch:startIndex><entry gd:etag='W/&quot;CEQCQn47eCp7I2A9WxNVFU8.&quot;'><id>http://www.google.com/calendar/feeds/default/calendars/alex%40example.com</id><published>2009-10-26T02:52:07.562Z</published><updated>2009-10-26T01:59:23.000Z</updated><app:edited xmlns:app='http://www.w3.org/2007/app'>2009-10-26T01:59:23.000Z</app:edited><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/gCal/2005#calendarmeta'/><title>alex@example.com</title><content type='application/atom+xml' src='http://www.google.com/calendar/feeds/alex%40example.com/private/full'/><link rel='alternate' type='application/atom+xml' href='http://www.google.com/calendar/feeds/alex%40example.com/private/full'/><link rel='http://schemas.google.com/gCal/2005#eventFeed' type='application/atom+xml' href='http://www.google.com/calendar/feeds/alex%40example.com/private/full'/><link rel='http://schemas.google.com/acl/2007#accessControlList' type='application/atom+xml' href='http://www.google.com/calendar/feeds/alex%40example.com/acl/full'/><link rel='self' type='application/atom+xml' href='http://www.google.com/calendar/feeds/default/owncalendars/full/alex%40example.com'/><link rel='edit' type='application/atom+xml' href='http://www.google.com/calendar/feeds/default/owncalendars/full/alex%40example.com'/><author><name>alex@example.com</name><email>alex@example.com</email></author><gCal:timezone value='America/New_York'/><gCal:timesCleaned value='0'/><gCal:hidden value='false'/><gCal:color value='#A32929'/><gCal:selected value='true'/><gCal:accesslevel value='owner'/></entry><entry gd:etag='W/&quot;CEQCQn47eCp7I2A9WxNVFU8.&quot;'><id>http://www.google.com/calendar/feeds/default/calendars/example.com_qppsjrgmnr4hin04g1uet0nkso%40group.calendar.google.com</id><published>2009-10-26T02:52:07.580Z</published><updated>2009-10-26T01:59:23.000Z</updated><app:edited xmlns:app='http://www.w3.org/2007/app'>2009-10-26T01:59:23.000Z</app:edited><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/gCal/2005#calendarmeta'/><title>Public</title><summary></summary><content type='application/atom+xml' src='http://www.google.com/calendar/feeds/example.com_qppsjrgmnr4hin04g1uet0nkso%40group.calendar.google.com/private/full'/><link rel='alternate' type='application/atom+xml' href='http://www.google.com/calendar/feeds/example.com_qppsjrgmnr4hin04g1uet0nkso%40group.calendar.google.com/private/full'/><link rel='http://schemas.google.com/gCal/2005#eventFeed' type='application/atom+xml' href='http://www.google.com/calendar/feeds/example.com_qppsjrgmnr4hin04g1uet0nkso%40group.calendar.google.com/private/full'/><link rel='http://schemas.google.com/acl/2007#accessControlList' type='application/atom+xml' href='http://www.google.com/calendar/feeds/example.com_qppsjrgmnr4hin04g1uet0nkso%40group.calendar.google.com/acl/full'/><link rel='self' type='application/atom+xml' href='http://www.google.com/calendar/feeds/default/owncalendars/full/example.com_qppsjrgmnr4hin04g1uet0nkso%40group.calendar.google.com'/><link rel='edit' type='application/atom+xml' href='http://www.google.com/calendar/feeds/default/owncalendars/full/example.com_qppsjrgmnr4hin04g1uet0nkso%40group.calendar.google.com'/><author><name>Public</name></author><gCal:timezone value='UTC'/><gCal:timesCleaned value='0'/><gCal:hidden value='false'/><gCal:color value='#AB8B00'/><gCal:selected value='true'/><gCal:accesslevel value='root'/><gd:where valueString=''/></entry></feed>", \
        200
      end
    end
    
    def post(path, options={})
      case path
      when "https://www.google.com/accounts/ClientLogin"
        Response.new "SID=DQAAAHUAAAAeTNZmd5wSCUnoPXXI9zc08MQfb57XNDoimahN3MJPn2jnPX5WNbrMxu5Iwvxg3qTWGr5irUMKE_-0AGgxYJwpzmyawgWs07FabVZZgSyUndPmy6g0YV9pXEJZf8zsymJDUtJ8mL88C_248bo5WjNHFg0PWDp_TryjTMEA\nLSID=DQAAAHYAAAAOiu229Qdzqbp19HZnI6myVs7x-BkVTnjdf_wlBGKwF2NBSld__YdI6TU2UeRSd85fJrPyRfLVqTiyvo9mEsE8l82GYrE-HYdnW5b6DRzJoek0fTBufcVI4F6HGnQM85yWXqGdlZlXwmkiOSFLEnHSzwFMPZkUCErfEiKotA\nAuth=DQAAAHgAAOiu229Qdzqbp19HZnI6myVs7x-BkVTnjdf_wGOlBGKwF2NBSld__Y6TU2UeRSfYZ4BNINeeXoEPd6csb3DC7L427Dj2pstLbKAVvDYhOH-SQ61E8mEZEccUm75y9zoLGeCOkCQAougTYEXgNHWOp5k-FfHH1MsW-WzbA\n", \
        200
      end
    end
  end
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  class Response < BlankSlate #:nodoc:
    attr_accessor :body, :code, :headers

    def initialize(body, code, headers={})
      @body = body
      @code = code.to_i
      @headers = headers
    end
    
    def method_missing(name, *args, &block)
      @body
    end
  end
  
end