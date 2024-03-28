# frozen_string_literal: true

# spec/mailers/notification_mailer_spec.rb
require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe '#new_announcement' do
    let(:announcement) { create(:announcement) } # Assuming you have a factory for Announcement model

    it 'sends a new announcement email' do
      email = NotificationMailer.new_announcement(announcement, 'example.com', 3000).deliver_now

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(email.to).to eq(User.pluck(:email))
      expect(email.from).to eq([ENV['EMAIL_USERNAME']])
      expect(email.subject).to eq("New MABS Announcement - #{announcement.subject}")
      expect(email.body.encoded).to include(announcement_url(announcement, host: 'example.com', port: 3000))
    end
  end

  describe '#edit_announcement' do
    let(:announcement) { create(:announcement) } # Assuming you have a factory for Announcement model

    it 'sends an edit announcement email' do
      email = NotificationMailer.edit_announcement(announcement, 'example.com', 3000).deliver_now

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(email.to).to eq(User.pluck(:email))
      expect(email.from).to eq([ENV['EMAIL_USERNAME']])
      expect(email.subject).to eq("Update to MABS Announcement - #{announcement.subject}")
      expect(email.body.encoded).to include(announcement_url(announcement, host: 'example.com', port: 3000))
    end
  end
end
