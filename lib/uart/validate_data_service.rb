# frozen_string_literal: true

# TODO: extend this snippet
module UART
  class << self
    def validate_data(data)
      true
    end

    def valid_size?(data)
      data.size == 8
    end

    def valid_format?(data)
      true
    end
  end
end
