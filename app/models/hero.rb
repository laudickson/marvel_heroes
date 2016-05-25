class Hero < ActiveRecord::Base
  has_many :heroevents
  has_many :events, through: :heroevents

  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :comic_total, presence: true
  validates :series_total, presence: true
  validates :story_total, presence: true
  validates :event_total, presence: true
end
