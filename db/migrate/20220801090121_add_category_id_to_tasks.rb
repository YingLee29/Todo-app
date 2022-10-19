class AddCategoryIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :category, index: true
  end
end
