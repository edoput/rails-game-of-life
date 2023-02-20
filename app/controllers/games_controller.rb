class GamesController < ApplicationController
  def index
    @games = Game.all #TODO(edoput) pagination
  end

  def show
    @game = Game.find(params[:id])
    @initial_generation = @game.generations.find_by(initial: true)
    @current_generation = @game.generations.order(step: :desc).first
  end

  def new
    @game = Game.new()
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to @game
    else
      render :new, status: :unprocessable_entity
    end
  end

  #TODO(edoput) destroy

  private
  def game_params
    params.require(:game).permit(:name)
  end
end
