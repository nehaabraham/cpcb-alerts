require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @event = Event.new(title: "Test event", date: Date.new(2018, 2, 14), time: Time.now.tomorrow, location: "Fishbowl", description: "Test description for text event")
  end

  test "event should be valid" do
    assert @event.valid?
  end

  test "title should be present" do
    @event.title = " "
    assert_not @event.valid?
  end

  test "date should be present" do
    @event.date = nil
    assert_not @event.valid?
  end

  test "time should be present" do
    @event.time = nil
    assert_not @event.valid?
  end

  test "location should be present" do
    @event.location = " "
    assert_not @event.valid?
  end

  test "description should be present" do
    @event.description = " "
    assert_not @event.valid?
  end

  test "event date should be after current date" do
    @event.date = Date.new(2016,1,1)
    assert_not @event.valid?
  end

end
