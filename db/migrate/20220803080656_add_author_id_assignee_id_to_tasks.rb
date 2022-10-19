class AddAuthorIdAssigneeIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :author_id, :integer, null: false
    add_column :tasks, :assignee_id, :integer
  end
end
