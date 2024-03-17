# frozen_string_literal: true

# spec/factories/setup.rb
FactoryBot.define do
  factory :setup, class: OpenStruct do
    user
    admin { create(:admin, uid: user.uid) }
    event { create(:event) }
    attendance { create(:attendance, event:, user:) }
    point { create(:point, awardedBy: admin, awardedTo: user) }

    initialize_with { new(attributes) }
  end
end
