# frozen_string_literal: true

class Server < ApplicationRecord
  include AASM

  has_one :port, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  after_update_commit :change_state
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

  private

  def change_state
    ActionCable.server.broadcast('servers_channel', { html: rendered_server, dom_id: "server_#{id}", event_id: 'server_update' })
  end

  def rendered_server
    ApplicationController.renderer.render(partial: 'web/servers/server', locals: { server: self })
  end
end
