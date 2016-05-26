class CreateHeroes < ActiveRecord::Migration
  def change
    create_table :heroes do |t|
      t.string :name
      t.text :description
      t.string :comic_total
      t.string :series_total
      t.string :story_total
      t.string :event_total
      t.string :avatar_url
    end
  end
end
