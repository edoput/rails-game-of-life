class GenerationsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @generation = @game.generations.find(params[:id])
    # TODO(edoput) spawn async task for creating next step of board
  end

  def create
    @game = Game.find(params[:game_id])
    if @game.started?
      redirect_to @game
    end
    input = params[:generation][:initial_board].open()
    initial_step = read_generation(input)
    #TODO(edoput) put width and height somewhere
    _, _ = read_dimensions(input)
    board = read_board(input)
    @game.generations.create(initial: true, step: initial_step, board: board)
    input.close()
    redirect_to @game
  end

  def next
    @game = Game.find(params[:game_id])
    @generation = @game.generations.find(params[:generation_id])
    redirect_to @generation.next_generation
  end

  def previous
    @game = Game.find(params[:game_id])
    @generation = @game.generations.find(params[:generation_id])
    redirect_to @generation.previous_generation
  end

  private
  def generation_params
    params.require(:game).permit(:initial_board)
  end

  # TODO(edoput) move parsing of file somewhere else?

  def read_generation(i)
    _, gen, *_ = i.readline.split
    return Integer(gen[0...-1])
  end

  def read_dimensions(i)
    width, height, *_ = i.readline.split
    return Integer(width), Integer(height)
  end

  def read_board(i)
    i.readlines.map{|l| l.rstrip.chars }
  end
end
