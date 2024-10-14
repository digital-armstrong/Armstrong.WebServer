# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Testing servers CRUD and any query', type: :request do
  let(:server) { FactoryBot.create(:server) }
  context 'Post /Server' do
    it 'should create server with valid params' do
      post servers_path, params: { server: { name: server.name, port_attributes: { name: server.port.name, rate: server.port.rate } } }
      expect(Server.find_by(id: server.id).present?).to eq(true)
    end
  end

  context 'Post /Server polling_test' do
    server_with_invalid_port = FactoryBot.create(:server)

    connected_devices = Dir.glob('/dev/ttyUSB*')
    server_with_valid_port = Server.create(name: 'test', port_attributes: { name: connected_devices.sample, rate: 9600 })

    it 'should start polling and change server state to panic with invalid port' do
      post start_polling_server_path(server_with_invalid_port)
      server_with_invalid_port.reload
      expect(server_with_invalid_port.aasm_state).to eq('panic')
    end

    it 'should start polling and change server state to polling with valid port' do
      post start_polling_server_path(server_with_valid_port)
      server_with_valid_port.reload
      expect(server_with_valid_port.aasm_state).to eq('polling')
    end

    it 'should stop polling and change server state to idle' do
      post stop_polling_server_path(server_with_invalid_port)
      server_with_invalid_port.reload
      expect(server_with_invalid_port.aasm_state).to eq('idle')
      post stop_polling_server_path(server_with_valid_port)
      server_with_valid_port.reload
      expect(server_with_valid_port.aasm_state).to eq('idle')
    end
  end

  context 'Get /Server' do
    it 'should redirect to root if server is polling' do
      server.start_polling!
      get edit_server_path(server)
      expect(response).to redirect_to(root_path)
    end

    it 'should redirect to edit if server is idle and do edit' do
      get edit_server_path(server)
      expect(response).to have_http_status(:ok)
      server_params = { name: 'test123', port_attributes: { name: 'test', rate: 9600 } }
      server.update(server_params)
      expect(server.name == 'test123').to be(true)
    end
  end

  context 'Delete /Server' do
    it 'should complete server deletion' do
      delete server_path(server)
      expect(Server.find_by(id: server.id).present?).to eq(false)
    end
  end
end
