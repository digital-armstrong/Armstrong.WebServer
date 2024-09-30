# frozen_string_literal: true

class Server < ApplicationRecord
  include AASM

  has_one :port, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :port

  aasm column: :aasm_state do
    state :idle, initial: true
    state :polling, :panic

    event :ready_to_polling do
      transitions from: %i[polling panic], to: :idle
    end

    event :start_polling do
      transitions from: :idle, to: :polling
    end

    event :panic do
      transitions from: :polling, to: :panic
    end
  end
end
