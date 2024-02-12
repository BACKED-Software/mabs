# location: spec/models/announcement_spec.rb
require 'rails_helper'

RSpec.describe Announcement, type: :model do
  subject do
    described_class.new(
      googleUserID: 'example_user_id',
      subject: 'Example Subject',
      dateOfAnnouncement: DateTime.now,
      body: 'Example Body'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a googleUserID' do
    subject.googleUserID = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a subject' do
    subject.subject = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a dateOfAnnouncement' do
    subject.dateOfAnnouncement = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a body' do
    subject.body = nil
    expect(subject).not_to be_valid
  end
end
