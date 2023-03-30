class GamesController < ApplicationController
  # before_action :validate_rolls, only: [:rolls]
  rescue_from ActiveRecord::RecordInvalid, :with => :invalid_error_render

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
    params[:input].split(',').map(&:strip)
  end

  def invalid_error_render(error)
    render json: error
  end
end