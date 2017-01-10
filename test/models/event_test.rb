require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @event = Event.new(title: "Test event",
      start: DateTime.now,
      end: DateTime.now + 1.day,
      location: "Fishbowl",
      description: "Test description for text event")
  end

  test "event should be valid" do
    assert @event.valid?
  end

  test "title should be present" do
    @event.title = " "
    assert_not @event.valid?
  end

  test "date should be present" do
    @event.start = nil
    assert_not @event.valid?
  end

  test "end time should be present" do
    @event.end = nil
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
    @event.start = DateTime.now - 1.hour
    assert_not @event.valid?
  end

  test "event end should be after event start" do
    @event.end = @event.start - 1.week
    assert_not @event.valid?
  end

end
