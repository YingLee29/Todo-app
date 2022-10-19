# frozen_string_literal: true

require "swagger_helper"
require "factory_bot_rails"

RSpec.describe "Api::TasksController", type: :request do
  describe "Task API" do
    # List Tasks
    path "/api/categories/{category_id}/tasks" do
      get "list task" do
        tags "Task"
        consumes "application/json"
        produces "application/json"
        parameter name: :category_id, in: :path, type: :integer

        response "200", "Successfully." do
          schema type: :array, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:category) { create(:category) }
          let(:category_id) { category.id }

          before do
            sign_in(user)
            create(:task, category_id: category.id, author: user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.length).to eq(1)
            expect(response.status).to eq(200)
          end
        end

        response "401", "Unauthorized" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:category) { create(:category) }
          let(:category_id) { category.id }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["error"]).to eq "You need to sign in or sign up before continuing."
            expect(response.status).to eq(401)
          end
        end
      end
    end

    path "/api/tasks/" do
      # test_method_create
      post "create task" do
        tags "Task"
        consumes "application/json"
        produces "application/json"
        parameter name: :task, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            category_id: { type: :integer },
            start_at: { type: :string },
            end_at: { type: :string },
            deadline_at: { type: :string }
          }
        }

        response "201", "Created" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:category) { create :category }
          let(:task) do
            attributes_for :task, title: "momo", category_id: category.id, deadline_at: "08-08-2022",
                                  start_at: "03-08-2022", end_at: "04-08-2022"
          end

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["title"]).to eq(task[:title])
            expect(response.status).to eq(201)
          end
        end

        response "401", "Unauthorized" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer }
          }

          let(:task) { attributes_for :task }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["error"]).to eq "You need to sign in or sign up before continuing."
            expect(response.status).to eq(401)
          end
        end

        response "422", "Unprocessable Entity" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:task) { attributes_for :task, deadline_at: nil }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq("Deadline at can't be blank")
            expect(response.status).to eq(422)
          end
        end
      end
    end

    path "/api/tasks/{id}" do
      get "show task" do
        tags "Task"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer

        response "200", "Ok." do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:task) do
            create :task, title: "momo", deadline_at: "08-08-2022",
                          start_at: "03-08-2022", end_at: "04-08-2022"
          end
          let(:id) { task.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["id"]).to eq(task.id)
            expect(data["title"]).to eq(task.title)
            expect(data["status"]).to eq(task.status)
            expect(response.status).to eq(200)
          end
        end

        response "404", "Not Found." do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:task) { create :task }
          let(:id) { 0 }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq("Not Found")
            expect(response.status).to eq(404)
          end
        end
      end

      delete "Delete task" do
        tags "Task"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer

        response "204", "No Content" do
          let(:user) { create(:user) }
          let(:task) { create(:task) }
          let(:id) { task.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            expect(response).to have_http_status(:no_content)
          end
        end
      end

      patch "update task" do
        tags "Task"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer
        parameter name: :task, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            category_id: { type: :integer },
            start_at: { type: :string },
            end_at: { type: :string },
            deadline_at: { type: :string }
          }
        }

        response "200", "Updated" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:task_exist) { create(:task, author: user) }
          let(:task) { attributes_for :task, title: "momo" }
          let(:id) { task_exist.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["title"]).to eq(task[:title])
            expect(response.status).to eq(200)
          end
        end

        response "401", "Unauthorized" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer }
          }

          let(:task_exist) { create(:task) }
          let(:task) { attributes_for :task }
          let(:id) { task_exist.id }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["error"]).to eq "You need to sign in or sign up before continuing."
            expect(response.status).to eq(401)
          end
        end

        response "422", "Unprocessable Entity" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:task) { attributes_for :task, deadline_at: nil }
          let(:task_exist) { create(:task, author: user) }
          let(:id) { task_exist.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq("Deadline at can't be blank")
            expect(response.status).to eq(422)
          end
        end
        response "401", "Unauthorized" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            priority: { type: :string },
            start_at: { type: :string },
            end_at: { type: :string },
            schedule_type: { type: :string },
            author_id: { type: :integer }
          }

          let(:user) { create(:user) }
          let(:task_exist) { create(:task) }
          let(:task) { attributes_for :task, title: "momo" }
          let(:id) { task_exist.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq "Unauthorized"
            expect(data["errors"]).to eq ["not allowed to update? this Task"]
            expect(response.status).to eq(401)
          end
        end
      end
    end

    path "/api/tasks/{id}/update_assignee" do
      patch "update assignee_id task" do
        tags "Task"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer
        parameter name: :task, in: :body, schema: {
          type: :object,
          properties: {
            assignee_id: { type: :integer }
          },
          required: %w[assignee_id]
        }

        response "200", "Updated" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            priority: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer },
            updated_at: { type: :string }
          }

          let(:user) { create(:user) }
          let(:task_exist) { create(:task, author: user) }
          let(:task) { attributes_for :task, assignee_id: 4 }
          let(:id) { task_exist.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["assignee_id"]).to eq(task[:assignee_id])
            expect(response.status).to eq(200)
          end
        end

        response "401", "Unauthorized" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            priority: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer },
            updated_at: { type: :string }
          }

          let(:task_exist) { create(:task) }
          let(:task) { attributes_for :task, assignee_id: 4 }
          let(:id) { task_exist.id }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["error"]).to eq "You need to sign in or sign up before continuing."
            expect(response.status).to eq(401)
          end
        end

        response "401", "Unauthorized" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            priority: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer },
            updated_at: { type: :string }
          }

          let(:user) { create(:user) }
          let(:task_exist) { create(:task) }
          let(:task) { attributes_for :task, assignee_id: 4 }
          let(:id) { task_exist.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq "Unauthorized"
            expect(data["errors"]).to eq ["not allowed to update_assignee? this Task"]
            expect(response.status).to eq(401)
          end
        end

        response "422", "Unprocessable Entity" do
          schema type: :object, properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            title: { type: :string },
            status: { type: :boolean },
            deadline_at: { type: :string },
            created_at: { type: :string },
            priority: { type: :string },
            author_id: { type: :integer },
            assignee_id: { type: :integer },
            updated_at: { type: :string }
          }

          let(:user) { create(:user) }
          let(:task_exist) { create(:task, author: user) }
          let(:task) { attributes_for :task, assignee_id: 4 }
          let(:id) { task_exist.id }

          before do
            sign_in(user)
            user.destroy
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq("Author must exist")
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end
end
