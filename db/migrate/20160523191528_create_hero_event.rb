class CreateHeroEvent < ActiveRecord::Migration
  def change
    create_table :heroesevents do |t|
      t.belongs_to :hero, null: false
      t.belongs_to :event, null: false
    end
  end
end
