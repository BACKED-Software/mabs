require 'rails_helper'

RSpec.describe Point, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user)
      point = build(:point, awardedTo: user.uid)
      expect(point).to be_valid
    end

    it 'is not valid without numPointsAwarded' do
      point = build(:point, numPointsAwarded: nil)
      expect(point).not_to be_valid
    end

    it 'is not valid with a negative numPointsAwarded' do
      point = build(:point, numPointsAwarded: -5)
      expect(point).not_to be_valid
    end

    it 'is not valid without awardedBy' do
      point = build(:point, awardedBy: nil)
      expect(point).not_to be_valid
    end

    it 'is not valid without awardedTo' do
      point = build(:point, awardedTo: nil)
      expect(point).not_to be_valid
    end

    it 'is not valid without dateOfAward' do
      point = build(:point, dateOfAward: nil)
      expect(point).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
  end
end
