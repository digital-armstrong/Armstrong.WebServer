# frozen_string_literal: true

class Server < ApplicationRecord
  has_one :port, dependent: :destroy

  validates :name, presence: true, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex

  accepts_nested_attributes_for :port
end
