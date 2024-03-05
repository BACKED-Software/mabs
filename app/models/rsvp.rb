class Rsvp < ApplicationRecord
    belongs_to :user, primary_key: 'uid', foreign_key: 'user_uid'
    belongs_to :event
  end