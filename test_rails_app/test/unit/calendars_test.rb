require File.dirname(__FILE__) + '/../test_helper'

class CalendarsTest < ActiveSupport::TestCase
  def setup
    @g = GoogleApps::CalendarsConnection.new
  end
  
  test "list calendars" do
    assert_equal 2, @g.calendars.size
  end
end