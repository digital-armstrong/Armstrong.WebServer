# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :port do
    name { ['/dev/ttyUSB0', '/dev/ttyUSB1', Faker::Name.name].sample }
    rate { FFaker::Number.number }
  end
end
