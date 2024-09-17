# frozen_string_literal: true

class Server < ApplicationRecord
  has_one :port, dependent: :destroy

  accepts_nested_attributes_for :port
end
