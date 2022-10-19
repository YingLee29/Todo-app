# frozen_string_literal: true

require "rails_helper"

describe TaskPolicy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:user_not_allow) { create(:user) }
  let(:category) { create(:category) }
  let(:context) { CurrentContext.new(user, { "category_id" => category.id }) }
  let(:context_not_allow) { CurrentContext.new(user_not_allow, { "category_id" => category.id }) }
  let(:task) { create(:task, author: user, category: category) }

  permissions :index? do
    before do
      task
    end
    it "allow show list tasks" do
      expect(subject).to permit(context)
    end

    it "not allow show list tasks" do
      expect(subject).not_to permit(context_not_allow)
    end
  end

  permissions :update?, :update_assignee? do
    it "allow update tasks or update assigneed" do
      expect(subject).to permit(context, task)
    end

    it "not allow  update tasks or update assigneed" do
      expect(subject).not_to permit(context_not_allow, task)
    end
  end
end
