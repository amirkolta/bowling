require "test_helper"

class RollsProcessorTest < ActiveSupport::TestCase
  test "should generate frames with correct structure" do
    g = games(:game_one)
    processor = RollsProcessor.new(g)

    processor.process(['Strike', '7', 'Spare', '9', 'Miss', 'Strike', 'Miss', '8', '8', 'Spare', 'Miss', '6', 'Strike', 'Strike', 'Strike', '8', '1'])

    assert_equal g.frames.size, 10
    assert_equal g.frames[0].rolls, ['Strike']
    assert_equal g.frames[1].rolls, ["7", "Spare"]
    assert_equal g.frames[2].rolls, ["9", "Miss"]
    assert_equal g.frames[3].rolls, ['Strike']
    assert_equal g.frames[4].rolls, ["Miss", "8"]
    assert_equal g.frames[5].rolls, ["8", "Spare"]
    assert_equal g.frames[6].rolls, ["Miss", "6"]
    assert_equal g.frames[7].rolls, ['Strike']
    assert_equal g.frames[8].rolls, ['Strike']
    assert_equal g.frames[9].rolls, ["Strike", "8", "1"]
  end

  test "it ignores any input past the last frame" do
    g = games(:game_one)
    processor = RollsProcessor.new(g)

    processor.process(['Strike', '7', 'Spare', '9', 'Miss', 'Strike', 'Miss', '8', '8', 'Spare', 'Miss', '6', 'Strike', 'Strike', 'Strike', '8', '1'])
    processor.process(['Strike'])

    assert_equal g.frames.size, 10
    assert_equal g.frames[9].rolls, ["Strike", "8", "1"]
  end

  test "it processes normally when the game is mid frame" do
    g = games(:game_one)
    processor = RollsProcessor.new(g)

    processor.process(['Strike', '7'])
    processor.process(['Spare', '9', 'Miss'])

    assert_equal g.frames.size, 4
    assert_equal g.frames[0].rolls, ['Strike']
    assert_equal g.frames[1].rolls, ["7", "Spare"]
    assert_equal g.frames[2].rolls, ["9", "Miss"]
  end

  test "it accepts input that ends mid frame" do
    g = games(:game_one)
    processor = RollsProcessor.new(g)

    processor.process(['Strike', '7', 'Spare'])
    processor.process(['9'])

    assert_equal g.frames.size, 3
    assert_equal g.frames[0].rolls, ['Strike']
    assert_equal g.frames[1].rolls, ["7", "Spare"]
    assert_equal g.frames[2].rolls, ["9"]
  end

  test "score doesn't change on Miss" do
    g = games(:game_one)
    processor = RollsProcessor.new(g)

    processor.process(['1', '1'])
    assert_equal g.get_frame(1).score, 2

    processor.process(['Miss'])

    assert_equal g.get_frame(1).score, 2
    assert_equal g.get_frame(2).score, 2
  end

  test "does not give retrospective bonus for third roll in final frame" do
    g = Game.create
    processor = RollsProcessor.new(g)

    processor.process(['Strike', '7', 'Spare', '9', 'Miss', 'Strike', 'Miss', '8', '8', 'Spare', 'Miss', '6', 'Strike', 'Strike', 'Strike', '8'])
    assert_equal g.get_frame(9).score, 148
    assert_equal g.get_frame(10).score, 166

    processor.process(['2'])
    assert_equal g.get_frame(9).score, 148
    assert_equal g.get_frame(10).score, 168
  end

  test "updates the score if only one strike is behind" do
    g = Game.create
    processor = RollsProcessor.new(g)

    processor.process(['Strike', '7', 'Spare', '9', 'Miss', 'Strike'])
    assert_equal g.get_frame(4).score, 58

    processor.process(['1'])
    assert_equal g.get_frame(4).score, 59

    processor.process(['8'])
    assert_equal g.get_frame(4).score, 67
  end

  test "updates the score as far as 2 strikes in previous frames" do
    g = Game.create
    processor = RollsProcessor.new(g)

    processor.process(['Strike', 'Strike'])
    assert_equal g.get_frame(1).score, 20
    assert_equal g.get_frame(2).score, 30

    processor.process(['8'])
    assert_equal g.get_frame(1).score, 28
    assert_equal g.get_frame(2).score, 46
  end

  test "updates the score for spare in the previous frame" do
    g = Game.create
    processor = RollsProcessor.new(g)

    processor.process(['Strike', '7', 'Spare'])
    assert_equal g.get_frame(1).score, 20
    assert_equal g.get_frame(2).score, 30

    processor.process(['1'])
    assert_equal g.get_frame(2).score, 31

    processor.process(['1'])
    assert_equal g.get_frame(2).score, 31
  end

  test "adds score to current frame" do
    g = Game.create
    processor = RollsProcessor.new(g)

    processor.process(['Strike'])
    assert_equal g.get_frame(1).score, 10
  end

  test "returns if game is done" do
  end
end
