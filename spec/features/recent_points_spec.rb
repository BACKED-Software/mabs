require 'rails_helper'

RSpec.describe "User's history", type: :feature do
  let(:setup) { create(:setup) }

  before do
    login_as(setup.user)
    visit root_path
  end

  it 'shows the most recent point' do
    expect(page).to have_content(setup.point.awardDescription)
    expect(page).to have_content(setup.point.numPointsAwarded)
  end

  it 'shows the most recent attendance' do
    expect(page).to have_content(setup.attendance.created_at.strftime("%m/%y"))
    expect(page).to have_content("Attendance to #{setup.event.eventName}")
    expect(page).to have_content(setup.attendance.pointsAwarded)
  end

  context 'when there is no point history' do
    before do
      Point.delete_all
      visit root_path
    end

    it 'does not show any points' do
      expect(page).not_to have_content('Points')
    end
  end

  context 'when there is no attendance history' do
    before do
      Attendance.delete_all
      visit root_path
    end

    it 'does not show any attendances' do
      expect(page).not_to have_content('Attendances')
    end
  end
end