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

  test "should not save if a regular frame has more rolls after a strike" do
    frame = frames(:incorrect_strike_regular_frame)

    assert_not frame.save, 'You cannot roll more than onece before the 10th frame if you roll a strike'
  end

  test "should not save if a final frame has more than 3 rolls" do
    frame = frames(:final_frame_more_than_three_rolls)

    assert_not frame.save, 'You cannot roll more than 3 times in the 10th frame'
  end

  test "should not save if a final frame has more than 2 rolls and the first 2 rolls do not add up to 10" do
    frame = frames(:incorrect_bonus_final_frame)

    assert_not frame.save, 'You are not allowed a bonus roll in the final frame'
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

  test "#add_roll_and_get_knocked_pins" do
    frame = frames(:game_two_first_frame)
    assert_equal frame.add_roll_and_get_knocked_pins('Miss'), 0
    assert_equal frame.rolls, ['9', 'Miss']
  end

  test "#spare?" do
    assert frames(:spare_frame).spare?
    assert_not frames(:complete_frame).spare?
  end

  test "#strike?" do
    assert frames(:strike_frame).strike?
    assert_not frames(:spare_frame).strike?
  end

  test "#add_score" do
    frame = frames(:incomplete_frame)
    frame.add_score(1)
    assert_equal frame.score, 10
  end

  test "#final?" do
    assert_not frames(:incomplete_frame).final?
    assert frames(:final_complete_frame).final?
  end

  test "final_frame_bonus?" do
    #final frame with 10 knocked down and 3 rolls
    assert frames(:final_complete_frame).final_frame_bonus?
    assert frames(:final_ten_total_frame_complete).final_frame_bonus?

    #final frame with less than 10 knocked down and 2 rolls
    assert_not frames(:final_less_than_ten_total_frame).final_frame_bonus?
  end

  test "#size" do
    assert_equal frames(:final_complete_frame).size, 3
  end
end
