# frozen_string_literal: true

module Api
  class InvitationsController < ApplicationController
    def index
      invitations = current_user.invitations
      render json: invitations, status: :ok
    end

    def show
      invitation = current_user.invitations.find(params[:id])
      render json: invitation, status: :ok
    end

    def create
      invitation = current_user.invitations.new(invitation_params)

      if invitation.save
        render json: invitation, status: :created
      else
        render json: { message: invitation.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    def destroy
      invitation = current_user.invitations.find(params[:id])

      invitation.destroy
      head :no_content
    end

    def accept
      invitation = current_user.received_invitations.find(params[:id])

      invitation.accepted!
      render json: invitation, status: :ok
    end

    def reject
      invitation = current_user.received_invitations.find(params[:id])

      invitation.rejected!
      render json: invitation, status: :ok
    end

    def users
      render json: current_user.linked_invitations, status: :ok
    end

    private

    def invitation_params
      params.permit(:receiver_id)
    end
  end
end
