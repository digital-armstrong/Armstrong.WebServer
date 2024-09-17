class Server < ApplicationRecord
  has_one :port

  accepts_nested_attributes_for :port
end
