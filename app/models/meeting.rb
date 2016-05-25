class Meeting < ActiveRecord::Base
  belongs_to :hero
  belongs_to :event

  validates :hero_id, presence: true
  validates :event_id, presence: true
end
