class Game < ApplicationRecord
  has_many :generations, dependent: :destroy

  def started?
    self.generations.count != 0
  end
end
