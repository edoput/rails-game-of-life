class Game < ApplicationRecord
  has_many :generations, dependent: :destroy

  validates :width, comparison: { greater_than: 1 }, allow_blank: true
  validates :height, comparison: { greater_than: 1 }, allow_blank: true

  def started?
    self.generations.count != 0
  end
end
