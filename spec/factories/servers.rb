# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :server do
    name { FFaker::Name.name }
  end
  after(:build) do |server|
    port_attrs = attributes_for(:port)
    server.build_port(port_attrs)
  end
end
