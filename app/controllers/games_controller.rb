class GamesController < ApplicationController
  def create
    Game.create
  end

  def show
    @game = current_game
  end

  def rolls
    RollsProcessor.process(current_game, rolls_array)

    render json: current_game.reload.frames.select(:rolls, :score).to_json
  end

  private
  
  def rolls_array
    params[:rolls].split(',').map(&:strip)
  end
end