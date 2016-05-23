class Event < ActiveRecord::Base
  has_many :heroesevents
  has_many :heroes, through: :heroesevents

  validates :name, presence: true, uniqueness: true
end
