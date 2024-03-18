# frozen_string_literal: true

FactoryBot.define do
  factory :rsvp do
    user_uid { create(:user).uid }
    event_id { create(:event).id }
  end
end
  
