FactoryBot.define do
  factory :point do
    numPointsAwarded { 1 }
    awardedBy { "MyString" }
    awardedTo { "MyString" }
    dateOfAward { "2024-03-04 17:40:53" }
    awardDescription { "MyText" }
  end
end
