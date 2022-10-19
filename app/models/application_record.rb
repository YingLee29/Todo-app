# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  VALID_PASSWORD_REGEX = %r{\A[a-zA-Z0-9!@#$%\^&*)(=._\-\\`~\[\]{}|:;"'<>,?/]+\z}i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end
