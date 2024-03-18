FactoryBot.define do
    factory :announcement do
      googleUserID { create(:user).uid }
      subject { Faker::Lorem.sentence }
      body { Faker::Lorem.paragraph }
      dateOfAnnouncement { Faker::Date.between(from: 2.days.ago, to: Date.today)}
      # Add other necessary attributes
    end
  end