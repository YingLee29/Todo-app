# frozen_string_literal: true

require "swagger_helper"
require "factory_bot_rails"

RSpec.describe "Api::Categories", type: :request do
  describe "Category API" do
    path "/api/categories" do
      get "List category" do
        tags "Category"
        consumes "application/json"
        produces "application/json"
        response "200", "Successfully." do
          schema  type: :array,
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }

          let(:user) { create(:user) }

          before do
            sign_in(user)
            create(:category)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.length).to eq(1)
            expect(response.status).to eq(200)
          end
        end

        response "401", "Unauthorized" do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["error"]).to eq "You need to sign in or sign up before continuing."
            expect(response.status).to eq(401)
          end
        end
      end

      # Test create category

      post "Create category" do
        tags "Category"
        consumes "application/json"
        produces "application/json"
        parameter name: :category, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string }
          },
          required: %w[name]
        }
        response "201", "Successfully." do
          schema type: :object, properties: {
            id: { type: :integer },
            name: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          }

          let(:user) { create(:user) }
          let(:category) { attributes_for :category }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["name"]).to eq(category[:name])
            expect(response.status).to eq(201)
          end
        end

        response "422", "Unprocessable Entity" do
          let(:user) { create(:user) }
          let(:category) { attributes_for :category, name: nil }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq "Name can't be blank"
            expect(response.status).to eq(422)
          end
        end
      end
    end

    # Test show category

    path "/api/categories/{id}" do
      get "Show category" do
        tags "Category"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer
        response "200", "Successfully" do
          schema  type: :object,
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }

          let(:user) { create(:user) }
          let(:category) { create(:category) }
          let(:id) { category.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["id"]).to eq(category.id)
            expect(response.status).to eq(200)
          end
        end

        response "404", "Not Found" do
          let(:id) { 0 }
          let(:user) { create(:user) }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response.status).to eq(404)
            expect(data["message"]).to eq("Not Found")
          end
        end
      end

      # Delete category

      delete "Delete category" do
        tags "Category"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer

        response "204", "No Content" do
          let(:user) { create(:user) }
          let(:category) { create(:category) }
          let(:id) { category.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            expect(response).to have_http_status(:no_content)
          end
        end

        response "404", "Not Found" do
          let(:id) { 0 }
          let(:user) { create(:user) }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
            expect(data["message"]).to eq("Not Found")
          end
        end
      end

      # Update category
      patch "Update category" do
        tags "Category"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer
        parameter name: :category, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string }
          },
          required: %w[name]
        }
        response "200", "Successfully" do
          schema  type: :object,
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }

          let(:user) { create(:user) }
          let(:category_update) { create :category }
          let(:category) { attributes_for :category, name: "Dungdz" }
          let(:id) { category_update.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["id"]).to eq(category_update.id)
            expect(data["name"]).to eq(category[:name])
            expect(response.status).to eq(200)
          end
        end

        response "404", "Not Found" do
          let(:user) { create(:user) }
          let(:category) { create(:category) }
          let(:id) { 0 }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response.status).to eq(404)
            expect(data["message"]).to eq("Not Found")
          end
        end

        response "422", "Unprocessable Entity" do
          let(:user) { create(:user) }
          let(:category_update) { create :category }
          let(:category) { attributes_for :category, name: nil }
          let(:id) { category_update.id }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to eq "Name can't be blank"
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end
end
