class AddColumnsToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :start_at, :datetime, null: false
    add_column :tasks, :end_at, :datetime, null: false
    add_column :tasks, :schedule_type, :integer, default: 0
  end
end
