class NotToDo < ActiveRecord::Migration
    def self.up
      create_table :not2dos do |t|
         t.references :user, foreign_key: { to_table: :users }, index: true
         t.column :privacy, :integer, :default => 0
         t.column :participant_count, :integer, :default => 0
         t.column :content, :string, :limit => 256
         t.timestamps :null => false
      end
   end

   def self.down
      drop_table :not2dos
   end
end
