# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) do
    described_class.new(
      eventLocation: 'Sample Location',
      eventInfo: 'Sample Info',
      eventName: 'Sample Event',
      eventTime: DateTime.now,
      sponsor_title: 'Sample Sponsor',
      sponsor_description: 'Sample Description'
      # sponsor: Sponsor.create(name: "Sample Sponsor")
    )
  end

  it 'is valid with valid attributes' do
    expect(event).to(be_valid)
  end

  it 'is not valid without a location' do
    event.eventLocation = nil
    expect(event).to_not be_valid
  end

  it 'is not valid without info' do
    event.eventInfo = nil
    expect(event).to_not be_valid
  end

  it 'is not valid without a name' do
    event.eventName = nil
    expect(event).to_not be_valid
  end

  it 'is not valid without a time/date' do
    event.eventTime = nil
    expect(event).to_not be_valid
  end

  it 'can be deleted' do
    event.save
    expect { event.destroy }.to change(described_class, :count).by(-1)
  end

  # it 'is not valid without a title' do
  #   event.sponsor_title = nil
  #   expect(event).to_not be_valid
  # end

  # it 'is not valid without a description' do
  #   event.sponsor_description = nil
  #   expect(event).to_not be_valid
  # end

  # Add more tests as needed
end
