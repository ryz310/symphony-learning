require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "title is required" do
    task = Task.new(description: "desc only")
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end
end
