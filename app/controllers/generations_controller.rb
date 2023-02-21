require 'simulation'

class GenerationsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @generation = @game.generations.find(params[:id])
    unless @generation.next_available?
      StepJob.perform_later @game
    end
  end

  def create
    @game = Game.find(params[:game_id])
    if @game.started?
      redirect_to @game
    end

    input = params[:generation][:initial_board].open
    begin
      initial_step = Simulation.read_generation(input)
      width, height = Simulation.read_dimensions(input)
      @game.width = width
      @game.height = height
      @game.save
      board = Simulation.read_board(input, width, height)
      @game.generations.create(initial: true, step: initial_step, board: board)
      redirect_to @game
    rescue => exception
      logger.warn exception.message
      #TODO(edoput) this should also give back validation at the "parser" level
      redirect_to @game
    ensure
      input.close()
    end
  end

  def next
    @game = Game.find(params[:game_id])
    @generation = @game.generations.find(params[:generation_id])
    redirect_to game_generation_path(@game, @generation.next_generation)
  end

  def previous
    @game = Game.find(params[:game_id])
    @generation = @game.generations.find(params[:generation_id])
    redirect_to game_generation_path(@game, @generation.previous_generation)
  end

  private
  def generation_params
    params.require(:game).permit(:initial_board)
  end
end
