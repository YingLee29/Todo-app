class ChangeStatusToBeBooleanInTasks < ActiveRecord::Migration[7.0]
  def change
    change_column :tasks, :status, :boolean, default: false
  end
end
