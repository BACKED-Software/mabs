# frozen_string_literal: true

# app/helpers/application_helper.rb
# Helper methods for use across the application.
module ApplicationHelper
    def truncate_with_link(text, max_length, link_url)
        truncated_text = truncate(text, length: max_length, separator: ' ')
        if text.length > max_length
            truncated_text += link_to('(Read more)', link_url, target: '_blank', style: 'font-size: 14px;')
        end
        truncated_text.html_safe
    end

    def require_sign_in(&block)
        if user_signed_in?
            capture(&block)
        end
    end
end
