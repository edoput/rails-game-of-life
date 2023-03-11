require 'simulation'

class GenerationsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @generation = @game.generations.find(params[:id])
    unless @generation.next_available?
      StepJob.perform_later @game
    end
  end

  def new
    @game = Game.find(params[:game_id])
    render :new
  end

  def create
    @game = Game.find(params[:game_id])
    if @game.started?
      redirect_to @game
      return
    end

    begin
      input = params[:generation][:initial_board].open
      begin 
        puts "parsing generation header"
        initial_step = Simulation.read_generation(input)
      rescue ArgumentError
        @game.errors.add :parsing, "Cannot parse generation header"
        render :new, status: :unprocessable_entity
        return
      end

      begin 
        puts "parsing dimensions header"
        height, width = Simulation.read_dimensions(input)
      rescue ArgumentError
        @game.errors.add :parsing, "Cannot parse dimensions header"
        render :new, status: :unprocessable_entity
        return
      end

      @game.width = width
      @game.height = height
      if not @game.save then
        render :new, status: :unprocessable_entity
        return
      end

      puts "parsing board"
      s = Simulation.read_board(input, width, height)
      @game.generations.create!(initial: true, step: initial_step, board: s)
      redirect_to @game
    rescue ActiveRecord::RecordInvalid => invalid
      @game.errors.merge! invalid.record.errors
      render :new, status: :unprocessable_entity
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
