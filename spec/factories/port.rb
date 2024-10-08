# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :port do
    name { FFaker::Name.name }
    rate { FFaker::Number.number }
  end
end
