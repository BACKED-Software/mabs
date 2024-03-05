class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    return nil unless email =~ /@tamu.edu\z/

    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end

  validates :email, presence: true
  enum role: { student: 0, admin: 1}
  has_many :announcements, foreign_key: 'googleUserID'

  # Helper method to check if the user is an admin
  def admin?
    is_admin
  end
end
