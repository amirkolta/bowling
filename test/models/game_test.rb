require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "should not save if game has more than 10 frames" do
    game = games(:game_one)
    
    11.times do
      game.frames << Frame.new(position: 1, rolls: 'Strike', score: 0)
    end

    assert_not game.save
    assert_includes game.errors[:frames], 'is too long (maximum is 10 characters)'
  end
end
