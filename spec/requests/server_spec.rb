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

  context 'Delete /Server' do
    let(:server) { FactoryBot.create(:server) }

    it 'should delete a server' do
      delete server_path(server)
      expect(Server.find_by(id: server.id).present?).to eq(false)
    end
  end

  context 'Post /Server' do
    server = FactoryBot.create(:server)
    it 'should start polling' do
      post start_polling_server_path(server)
      server.reload
      expect(server.aasm_state).to eq('panic')
    end

    it 'should stop polling' do
      post stop_polling_server_path(server)
      server.reload
      expect(server.aasm_state).to eq('idle')
    end
  end

  context 'Post /Server' do
    connected_devices = Dir.glob('/dev/ttyUSB*')
    let(:mocked_server) { Server.create(name: 'test', port_attributes: { name: connected_devices.sample, rate: 9600 }) }

    it 'should start polling and change server state to polling' do
      post start_polling_server_path(mocked_server)
      mocked_server.reload
      expect(mocked_server.aasm_state).to eq('polling')
    end
  end
end
