class StepJob < ApplicationJob
  queue_as :default

  def perform(game)
    # Do something later
    current_generation = game.generations.order(step: :desc).first
    #TODO(edoput) actually compute the next board
    game.generations.create(step: current_generation.step+1, board: current_generation.board)
  end
end
