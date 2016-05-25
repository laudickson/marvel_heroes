class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.belongs_to :hero, null: false
      t.belongs_to :event, null: false
    end
  end
end
