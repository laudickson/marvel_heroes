class Event < ActiveRecord::Base
  has_many :heroevents
  has_many :heroes, through: :heroevents

  validates :name, presence: true, uniqueness: true
end
