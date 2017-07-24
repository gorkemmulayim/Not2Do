class AddFailedToParticipations < ActiveRecord::Migration[5.1]
  def change
    add_column :participations, :failed, :boolean, default: false
  end
end
