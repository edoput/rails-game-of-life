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


    begin
      input = params[:generation][:initial_board].open
      initial_step = Simulation.read_generation(input)
      width, height = Simulation.read_dimensions(input)
      @game.width = width
      @game.height = height
      @game.save
      s = Simulation.read_board(input, width, height)
      board = Simulation.from_string(s)
      if board.row_count != height or board.column_count != width then
        redirect_to @game
      end
      @game.generations.create(initial: true, step: initial_step, board: s)
      redirect_to @game
    rescue ActiveRecord::RecordInvalid => invalid
      #TODO(edoput) this is just for the game validation
      redirect_to @game
    rescue ArgumentError
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
