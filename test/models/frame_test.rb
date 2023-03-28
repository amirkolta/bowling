require "test_helper"

class FrameTest < ActiveSupport::TestCase
  test "parsed_rolls returns an array of rolls split on commas" do
    frame = frames(:valid_frame)

    assert_equal(frame.parsed_rolls, ['9', 'Miss'])
  end

  test "should not save if one of the rolls is invalid" do
    frame = frames(:frame_with_invalid_rolls)

    assert_not frame.save, 'Invalid roll detected'
  end

  test "should not save if frame has more than 2 rolls before last frame" do
    frame = frames(:frame_more_than_two_rolls)

    assert_not frame.save, 'You cannot roll more than twice before the 10th frame'
  end

  test "should not save if a final frame has more than 3 rolls" do
    frame = frames(:final_frame_more_than_three_rolls)

    assert_not frame.save, 'You cannot roll more than 3 times in the 10th frame'
  end
end
