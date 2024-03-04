# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  def self.from_google(email:, full_name:, uid:, avatar_url:)
    #return nil unless email =~ /@tamu.edu\z/

    create_with(uid:, full_name:, avatar_url:).find_or_create_by!(email:)
  end
  validates :email, presence: true
  has_many :announcements, foreign_key: 'googleUserID'
end
