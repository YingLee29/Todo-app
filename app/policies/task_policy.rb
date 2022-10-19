# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def index?
    category.tasks.ransack(author_id_or_assignee_id_eq: user.id).result.exists?
  end

  def update?
    user.id == record.author_id || user.id == record.assignee_id
  end

  def update_assignee?
    user.id == record.author_id
  end

  private

  def category
    Category.find(params["category_id"])
  end
end
