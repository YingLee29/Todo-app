# frozen_string_literal: true

module Api
  class SessionsController < Devise::SessionsController
    before_action :rewrite_param_user
    wrap_parameters :user

    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end

    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :notice, :signed_out if signed_out
      yield if block_given?
      respond_to_on_destroy
    end

    private

    def respond_with(resource, _opts = {})
      return render401 if resource.id.nil?

      token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)[0]
      render json: { data: resource.as_json, token: token }, status: :ok
    end

    def respond_to_on_destroy
      head :no_content
    end

    def rewrite_param_user
      return unless request.params[:password] && request.params[:email]

      request.params[:user] = { password: request.params[:password], email: request.params[:email] }
    end
  end
end
