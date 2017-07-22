class AddFailedToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :failed, :boolean, default: false
  end
end
