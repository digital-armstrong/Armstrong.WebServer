require 'rails_helper'
require 'database_cleaner/active_record'

RSpec.describe 'Servers', type: :request do
  context 'Post /Server' do
    let(:server) { FactoryBot.create(:server) }
    it 'should create a server with valid attributes' do
      post servers_path, params: { server: { name: server.name, port_attributes: { name: server.port.name, rate: server.port.rate } } }
      expect(Server.find_by(id: server.id).present?).to eq(true)
    end
  end

  context 'Post /Server' do
    let(:server) { FactoryBot.create(:server) }

    it 'should start polling' do
      post start_polling_server_path(server)
      server.reload
      puts server.aasm_state
      expect(server.aasm_state).to eq('panic')
    end

    it 'should stop polling' do
      puts "#{server.aasm_state}"
      post stop_polling_server_path(server)
      server.reload
      expect(server.aasm_state).to eq('idle')
    end
  end
end
