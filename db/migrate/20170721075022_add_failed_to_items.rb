class AddFailedToItems < ActiveRecord::Migration
  def change
    add_column :items, :failed, :boolean, default: false
  end
end
