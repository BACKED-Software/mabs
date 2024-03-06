# frozen_string_literal: true

class Attendance < ApplicationRecord
  belongs_to :event, foreign_key: 'eventID'
end
