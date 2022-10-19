# frozen_string_literal: true

module Api
  class RegistrationsController < Devise::RegistrationsController
    def create
      user = User.new(sign_up_params)
      if user.save
        render json: user.as_json, status: :created
      else
        render json: { message: user.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.permit(:email, :full_name, :password)
    end
  end
end
