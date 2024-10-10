# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Servers', type: :request do
  context 'Post /Server' do
    let(:server) { FactoryBot.create(:server) }
    it 'should create a server with valid attributes' do
      post servers_path, params: { server: { name: server.name, port_attributes: { name: server.port.name, rate: server.port.rate } } }
      expect(Server.find_by(id: server.id).present?).to eq(true)
    end
  end

  context 'Post /Server' do
    server = FactoryBot.create(:server)
    connected_devices = Dir.glob('/dev/ttyUSB*')
    it 'should start polling' do
      post start_polling_server_path(server)
      server.reload
      if connected_devices.any?(server.port.name)
        expect(server.aasm_state).to eq('polling')
      else
        expect(server.aasm_state).to eq('panic')
      end
    end

    it 'should stop polling' do
      post stop_polling_server_path(server)
      server.reload
      expect(server.aasm_state).to eq('idle')
    end
  end
end
