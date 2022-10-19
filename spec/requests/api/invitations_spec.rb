# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Api::InvitationsController", type: :request do
  describe "Invitations API" do
    let(:user) { create(:user) }

    before do
      sign_in(user)
    end

    path "/api/invitations" do
      get "List invitations" do
        tags "Invitation"
        produces "application/json"

        response "200", "Successfully" do
          schema type: :array,
                 properties: {
                   id: { type: :integer },
                   sender_id: { type: :integer },
                   receiver_id: { type: :integer },
                   status: { type: :string, enum: %w[waiting rejected accepted] },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }

          let(:receiver) { create(:user) }
          let(:invitation) { create(:invitation, sender: user, receiver: receiver) }

          before do
            invitation
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:ok)
            expect(data.length).to eq(1)
            expect(data[0]["id"]).to eq(invitation.id)
          end
        end
      end

      post "Create invitation" do
        tags "Invitation"
        consumes "application/json"
        produces "application/json"
        parameter name: :invitation, in: :body, schema: {
          type: :object,
          properties: {
            receiver_id: { type: :integer }
          },
          required: %w[receiver_id]
        }

        response "201", "Successfully" do
          schema type: :object,
                 properties: {
                   id: { type: :integer },
                   sender_id: { type: :integer },
                   receiver_id: { type: :integer },
                   status: { type: :string, enum: %w[waiting rejected accepted] },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }

          let(:receiver) { create(:user) }
          let(:invitation) { attributes_for(:invitation, receiver_id: receiver.id) }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:created)
            expect(data["id"]).to eq(Invitation.last.id)
            expect(data["receiver_id"]).to eq(receiver.id)
          end
        end

        response "422", "Unprocessable Entity" do
          let(:invitation) { attributes_for(:invitation, receiver_id: nil) }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data["message"]).to eq("Receiver must exist")
          end
        end

        response "422", "Unprocessable Entity" do
          let(:invitation) { attributes_for(:invitation, receiver_id: user.id) }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data["message"]).to eq("Receiver must be different from sender")
          end
        end

        response "422", "Unprocessable Entity" do
          let(:receiver) { create(:user) }
          let(:invitation) { attributes_for(:invitation, receiver_id: receiver.id) }
          let(:invitation_1) { create(:invitation, sender: user, receiver: receiver) }

          before do
            invitation_1
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data["message"]).to eq("Receiver already has an invitation")
          end
        end

        response "422", "Unprocessable Entity" do
          let(:user_1) { create(:user) }
          let(:invitation) { attributes_for(:invitation, receiver_id: user_1.id) }
          let(:invitation_1) { create(:invitation, sender: user_1, receiver: user) }

          before do
            invitation_1
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data["message"]).to eq("Receiver already has an invitation")
          end
        end
      end
    end

    path "/api/invitations/{id}" do
      get "Show invitation" do
        tags "Invitation"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer

        response "200", "Successfully" do
          schema type: :object,
                 properties: {
                   id: { type: :integer },
                   sender_id: { type: :integer },
                   receiver_id: { type: :integer },
                   status: { type: :string, enum: %w[waiting rejected accepted] },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }

          let(:receiver) { create(:user) }
          let(:invitation) { create(:invitation, sender: user, receiver: receiver) }
          let(:id) { invitation.id }

          before do
            invitation
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:ok)
            expect(data["id"]).to eq(invitation.id)
          end
        end

        response "404", "Not Found" do
          let(:id) { 0 }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
            expect(data["message"]).to eq("Not Found")
          end
        end
      end

      delete "Delete invitation" do
        tags "Invitation"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer

        response "204", "No Content" do
          let(:receiver) { create(:user) }
          let(:invitation) { create(:invitation, sender: user, receiver: receiver) }
          let(:id) { invitation.id }

          before do
            invitation
          end

          run_test! do |response|
            expect(response).to have_http_status(:no_content)
          end
        end

        response "404", "Not Found" do
          let(:id) { 0 }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
            expect(data["message"]).to eq("Not Found")
          end
        end
      end
    end

    path "/api/invitations/{id}/accept" do
      patch "Accept invitation" do
        tags "Invitation"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer

        response "200", "Successfully" do
          schema type: :object,
                 properties: {
                   id: { type: :integer },
                   sender_id: { type: :integer },
                   receiver_id: { type: :integer },
                   status: { type: :string, enum: %w[waiting rejected accepted] },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }
          let(:receiver) { create(:user) }
          let(:invitation) { create(:invitation, sender: receiver, receiver: user) }
          let(:id) { invitation.id }

          before do
            invitation
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:ok)
            expect(data["id"]).to eq(invitation.id)
            expect(data["status"]).to eq("accepted")
          end
        end

        response "404", "Not Found" do
          let(:id) { 0 }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
            expect(data["message"]).to eq("Not Found")
          end
        end
      end
    end

    path "/api/invitations/{id}/reject" do
      patch "Reject invitation" do
        tags "Invitation"
        consumes "application/json"
        produces "application/json"
        parameter name: :id, in: :path, type: :integer

        response "200", "Successfully" do
          schema type: :object,
                 properties: {
                   id: { type: :integer },
                   sender_id: { type: :integer },
                   receiver_id: { type: :integer },
                   status: { type: :string, enum: %w[waiting rejected accepted] },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }

          let(:receiver) { create(:user) }
          let(:invitation) { create(:invitation, sender: receiver, receiver: user) }
          let(:id) { invitation.id }

          before do
            invitation
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:ok)
            expect(data["id"]).to eq(invitation.id)
            expect(data["status"]).to eq("rejected")
          end
        end

        response "404", "Not Found" do
          let(:id) { 0 }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
            expect(data["message"]).to eq("Not Found")
          end
        end
      end
    end

    path "/api/invitations/users" do
      get "List User" do
        tags "Invitation"
        produces "application/json"

        response "200", "Successfully" do
          schema type: :array,
                 properties: {
                   id: { type: :integer },
                   sender_id: { type: :integer },
                   receiver_id: { type: :integer },
                   status: { type: :string, enum: %w[waiting rejected accepted] },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }

          let(:receiver) { create(:user) }
          let(:invitation) { create(:invitation, sender: user, receiver: receiver, status: :accepted) }

          before do
            invitation
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:ok)
            expect(data.length).to eq(1)
          end
        end
      end
    end
  end
end
