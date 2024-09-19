# frozen_string_literal: true

class Port < ApplicationRecord
  belongs_to :server

  validates :name, :rate, presence: true
  validates :name, uniqueness: true
end
