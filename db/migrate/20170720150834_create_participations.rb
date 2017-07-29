class CreateParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :participations do |t|
      t.integer :item_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
