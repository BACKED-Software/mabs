# frozen_string_literal: true

# app/helpers/application_helper.rb
# Helper methods for use across the application.
module ApplicationHelper
  def require_sign_in(&block)
    return unless user_signed_in?

    capture(&block)
  end
end
