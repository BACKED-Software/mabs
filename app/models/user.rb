# frozen_string_literal: true
require 'csv'

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    return nil unless email =~ /@tamu.edu\z/

    create_with(uid:, full_name:, avatar_url:, total_points: 0).find_or_create_by!(email:)
  end

  validates :email, presence: true
  has_many :announcements, foreign_key: 'googleUserID', dependent: :nullify
  has_many :rsvps, foreign_key: 'user_uid', dependent: :destroy
  has_many :attendances, foreign_key: 'googleUserID', dependent: :destroy
  has_many :points, foreign_key: 'awardedTo', primary_key: 'uid'

  # Helper method to check if the user is an admin
  def admin?
    is_admin
  end

  def self.to_csv
    attributes = %w{gender is_hispanic_or_latino race is_us_citizen is_first_generation_college_student classification}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  scope :by_gender, ->(gender) { where(gender: gender) if gender.present? }
  
  scope :by_race, ->(race) { where(race: race) if race.present? }
  
  scope :by_us_citizen, ->(is_us_citizen) { where(is_us_citizen: is_us_citizen) if !is_us_citizen.nil? }
  
  scope :by_first_generation_college_student, ->(is_first_generation) { where(is_first_generation_college_student: is_first_generation) if !is_first_generation.nil? }
  
  scope :by_hispanic_or_latino, ->(is_hispanic_or_latino) { where(is_hispanic_or_latino: is_hispanic_or_latino) if !is_hispanic_or_latino.nil? }
  
  scope :by_classification, ->(classification) { where(classification: classification) if classification.present? }
  
end
