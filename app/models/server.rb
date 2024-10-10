# frozen_string_literal: true

class Server < ApplicationRecord
  include AASM

  has_one :port, dependent: :destroy
  accepts_nested_attributes_for :port

  validates :name, presence: true, uniqueness: true

  after_update_commit :server_update
  after_create_commit :server_create

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

  # TODO: maybe we need create repository?
  #       need discussion about it.
  def server_update
    ActionCable.server.broadcast('servers_channel', { html: rendered_server, htmlId: "server_#{id}", eventId: 'server_update' })
  end

  def server_create
    ActionCable.server.broadcast('servers_channel', { html: rendered_server, htmlId: 'servers_body', eventId: 'server_create' })
  end

  def rendered_server
    ApplicationController.renderer.render(partial: 'web/servers/server', locals: { server: self })
  end
end
