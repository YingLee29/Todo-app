# frozen_string_literal: true

require "swagger_helper"
require "factory_bot_rails"

RSpec.describe "Api::SessionsController", type: :request do
  describe "Login API" do
    path "/api/login" do
      post "Login user" do
        tags "User"
        consumes "application/json"
        produces "application/json"
        parameter name: :email, in: :path, type: :string
        parameter name: :password, in: :path, type: :string

        response "200", "Successfully." do
          schema type: :object, properties: {
            id: { type: :integer },
            email: { type: :string },
            full_name: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          }

          let(:user) { create(:user) }
          let(:email) { user.email }
          let(:password) { "password" }

          before do
            sign_in(user)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["id"]).to eq(user.id)
            expect(data["email"]).to eq(user[:email])
            expect(data["full_name"]).to eq(user[:full_name])
            expect(response.headers["Authorization"]).to be_present
            expect(response.status).to eq(200)
          end
        end

        response "401", "Login failed." do
          let(:user) { create(:user) }
          let(:email) { user.email }
          let(:password) { "" }
          run_test! do |response|
            expect(response.status).to eq(401)
          end
        end
      end
    end

    path "/api/logout" do
      delete "Logout user" do
        tags "User"
        consumes "application/json"
        produces "application/json"

        let(:user) { create(:user) }

        before do
          sign_in(user)
        end

        response "204", "Successfully." do
          run_test! do |response|
            expect(response.status).to eq(204)
          end
        end
      end
    end
  end
end
