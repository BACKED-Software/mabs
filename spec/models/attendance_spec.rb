# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'validations' do
    let(:attendance) do
      described_class.new(
        eventID: 1,
        googleUserID: 'example_user_id',
        timeOfCheckIn: DateTime.now,
        pointsAwarded: 10
      )
    end

    it 'is not valid without an eventID' do
      attendance.eventID = nil
      expect(attendance).not_to be_valid
    end

    it 'is not valid without a googleUserID' do
      attendance.googleUserID = nil
      expect(attendance).not_to be_valid
    end

    it 'is not valid without a timeOfCheckIn' do
      attendance.timeOfCheckIn = nil
      expect(attendance).not_to be_valid
    end

    it 'is not valid without pointsAwarded' do
      attendance.pointsAwarded = nil
      expect(attendance).not_to be_valid
    end
  end
end
