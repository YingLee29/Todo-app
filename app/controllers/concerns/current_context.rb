# frozen_string_literal: true

class CurrentContext
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end
end
