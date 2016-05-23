class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
    end
  end
end
