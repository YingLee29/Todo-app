# frozen_string_literal: true

require "swagger_helper"
require "factory_bot_rails"

RSpec.describe "Api::RegistrationsController", type: :request do
  describe "Register API" do
    path "/api/register" do
      post "Register User" do
        tags "User"
        consumes "application/json"
        produces "application/json"
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string },
            full_name: { type: :string }
          },
          required: %w[email password full_name]
        }

        response "201", "Successfully." do
          schema type: :object, properties: {
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                full_name: { type: :string },
                created_at: { type: :string },
                updated_at: { type: :string }
              }
            }
          }
          let(:user) { attributes_for :user, password: "password", email: "dungdz@gmail.com" }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["email"]).to eq(user[:email])
            expect(data["full_name"]).to eq(user[:full_name])
            expect(response.status).to eq(201)
          end
        end

        response "422", "Unprocessable Entity." do
          let(:user) { attributes_for :user, email: nil }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["message"]).to include "Email can't be blank"
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end
end
