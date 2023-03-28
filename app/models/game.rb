class Game < ApplicationRecord
  # Associations
  has_many :frames, :dependent => :destroy

  # Validations
  validates :frames, length: {maximum: 10}
end