require "test_helper"

class FrameTest < ActiveSupport::TestCase
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

  test "#complete?" do
    # regular frame with one roll that is not a strike
    assert_not frames(:incomplete_frame).complete?

    # regular frame with 2 rolls neither is a strike
    assert frames(:complete_frame).complete?

    # regular frame with 1 strike
    assert frames(:strike_frame).complete?

    # final frame with 3 rolls
    assert frames(:final_complete_frame).complete?

    # final frame with 1 roll
    assert_not frames(:final_incomplete_frame).complete?

    # final frame with 1 strike and 2 rolls
    assert_not frames(:final_strike_frame).complete?

    #final frame with 10 knocked down and 2 rolls
    assert_not frames(:final_ten_total_frame).complete?

    #final frame with 10 knocked down and 3 rolls
    assert frames(:final_ten_total_frame_complete).complete?

    #final frame with less than 10 knocked down and 2 rolls
    assert frames(:final_less_than_ten_total_frame).complete?
  end

  test "#incomplete?" do
    # regular frame with one roll that is not a strike
    assert frames(:incomplete_frame).incomplete?

    # regular frame with 2 rolls neither is a strike
    assert_not frames(:complete_frame).incomplete?

    # regular frame with 1 strike
    assert_not frames(:strike_frame).incomplete?

    # final frame with 3 rolls
    assert_not frames(:final_complete_frame).incomplete?

    # final frame with 1 roll
    assert frames(:final_incomplete_frame).incomplete?

    # final frame with 1 strike and 2 rolls
    assert frames(:final_strike_frame).incomplete?

    #final frame with 10 knocked down and 2 rolls
    assert frames(:final_ten_total_frame).incomplete?

    #final frame with 10 knocked down and 3 rolls
    assert_not frames(:final_ten_total_frame_complete).incomplete?

    #final frame with less than 10 knocked down and 2 rolls
    assert_not frames(:final_less_than_ten_total_frame).incomplete?
  end

  test "#add_roll" do
    frame = frames(:game_two_first_frame)
    frame.add_roll('1')
    assert_equal frame.rolls, ['9', '1']
  end
end
