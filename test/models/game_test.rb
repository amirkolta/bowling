require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "should not save if game has more than 10 frames" do
    game = games(:game_one)
    
    11.times do
      game.frames << Frame.new(position: 1, rolls: ['Strike'], score: 0)
    end

    assert_not game.save
    assert_includes game.errors[:frames], 'is too long (maximum is 10 characters)'
  end

  test "#current_frame" do
    game = games(:game_three)

    assert_equal game.current_frame, game.frames.last
  end

  test "#previous_frame" do
    # game with more than 1 frame
    game = games(:game_three)
    assert_equal game.previous_frame, game.frames.first

    # game with 1 frame
    game = games(:game_two)
    assert_nil game.previous_frame
  end

  test "#start_new_frame" do
    game = games(:game_two)

    assert_equal game.frames.size, 1

    game.start_new_frame

    assert_equal game.frames.size, 2
  end

  test "frames are loaded in order of position" do
    game = Game.create
    game.frames << Frame.new(position: 4)
    game.frames << Frame.new(position: 2)
    game.frames << Frame.new(position: 3)
    game.reload
    assert_equal game.frames[0].position, 1
    assert_equal game.frames[1].position, 2
    assert_equal game.frames[2].position, 3
    assert_equal game.frames[3].position, 4
  end

  test "#get_frame" do
    # gets frame by position
    assert_equal games(:game_three).get_frame(2).id, frames(:game_three_second_frame).id 

    # returns nil if out of bounds
    assert_nil games(:game_three).get_frame(5)
  end

  test "#complete?" do
    assert games(:complete_game).complete?
  end
end
