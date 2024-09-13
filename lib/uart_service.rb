require 'uart'
class UartService
  attr_accessor :port, :package, :retry_limit, :delay_time
  attr_reader   :retry_count
  @@threads = []

  def initialize(port, args = {})
    @port        = port
    @package     = args[:package]     || [0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x45, 0xCA]
    @retry_count = 0
    @retry_limit = args[:retry_limit] || 5
    @delay_time  = args[:delay_time]  || 5

    print_info
  end

  def print_info
    puts "\n\n================================"
    puts "Port:\t\t#{@port}"
    puts "Retry Limit:\t#{@retry_limit}"
    puts "Package:\t#{@package}"
    puts "Delay Time:\t#{@delay_time}"
    puts "================================\n\n"
  end

  def port_available?
    Dir.glob(@port).count == 1
  end

  def may_retry?
    retry_count < retry_limit
  end

  def polling
    @@threads << Thread.current
    loop do
      return unless may_retry?

      if port_available?
        UART.open @port do |serial|
          serial.write package.pack('C8')
          response = serial.read(8)

          puts "Time: #{DateTime.now.strftime("%F %T")}\t\tValue: #{response[2..6].unpack('F').first}"
        end

        @retry_count = 0
      else
        @retry_count += 1
        pp "Port #{@port} is not available... Retry step #{@retry_count}"
      end

      sleep(@delay_time)
    end
  end

  def start_polling
    r = Ractor.new do
      receive
    end
    r.send(polling)
  end

  def self.stop_polling
    @@threads&.each(&:kill)
  end

  def self.get_threads
    @@threads
  end
end
