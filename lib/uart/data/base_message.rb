# frozen_string_literal: true

# TODO: extend this snippet
module UART
  class BaseMessage
    attr_reader   :address, :function, :action1, :action2, :action3, :action4, :crc_low, :crc_high
    attr_accessor :data_package

    def initialize(bytes = {})
      @address      = bytes[:address]   || 0x01
      @function     = bytes[:function]  || 0x03
      @action1      = bytes[:action1]   || 0x00
      @action2      = bytes[:action2]   || 0x00
      @action3      = bytes[:action3]   || 0x00
      @action4      = bytes[:action4]   || 0x00
      @crc_low      = bytes[:crc_low]   || 0x00
      @crc_high     = bytes[:crc_high]  || 0x00
      @data_package = nil
    end

    def build_data
      @data_package = [@address, @function, @action1, @action2, @action3, @action4, @crc_low, @crc_high].pack('C*')
      # TODO: write builder
    end
  end
end
