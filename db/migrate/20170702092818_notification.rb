class Notification < ActiveRecord::Migration
    def self.up
      create_table :notifications do |t|
        t.references :user, foreign_key: { to_table: :users }, index: true
        t.string :message, :limit => 256, :null => false
        t.string :link, :limit => 256
        t.timestamps null: false
      end
   end

   def self.down
      drop_table :notifications
   end
end
