# frozen_string_literal: true

require 'uart'
class UartService
  attr_accessor :port, :package, :retry_limit, :delay_time
  attr_reader   :retry_count

  @@servers_threads = [] # rubocop:disable Style/ClassVars

  def initialize(port, args = {})
    @port        = port
    @package     = args[:package] || [0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x45, 0xCA]
    @retry_count = 0
    @retry_limit = args[:retry_limit] || 5
    @delay_time  = args[:delay_time]  || 5

    print_info
  end

  def print_info
    Rails.logger.debug "\n\n================================"
    Rails.logger.debug { "Port:\t\t#{@port}" }
    Rails.logger.debug { "Retry Limit:\t#{@retry_limit}" }
    Rails.logger.debug { "Package:\t#{@package}" }
    Rails.logger.debug { "Delay Time:\t#{@delay_time}" }
    Rails.logger.debug "================================\n\n"
  end

  def port_available?
    Dir.glob(@port).count == 1
  end

  def polling
    loop do
      if port_available?
        UART.open @port do |serial|
          serial.write package.pack('C8')
          response = serial.read(8)
          if response.nil?
            Rails.logger.info { "Invalid answer for port #{@port}..." }
          else
            @retry_count = 0
            Rails.logger.info { "Time: #{DateTime.now.strftime('%F %T')}\t\tValue: #{response[2..6].unpack1('F')}" }
          end
        end

      else
        @retry_count += 1
        Rails.logger.info { "Port #{@port} is not available... Retry step #{@retry_count}" }
      end

      sleep(@delay_time)
    end
  end

  def start_polling(server_id)
    return if @@servers_threads.any? { |t| t[:server_id] == server_id }

    @@servers_threads << {
      server_id:,
      thread: Thread.new do
        Rails.logger.info { "\033[32m#{I18n.t('thread.thread_started', server_id:)}" }
        polling
      end
    }
  end

  def stop_polling(server_id)
    detect_and_stop_server_thread(server_id)
  end

  private

  def detect_and_stop_server_thread(server_id)
    server_thread = @@servers_threads.detect { |t| t[:server_id] == server_id }

    if server_thread.nil?
      Rails.logger.info { "\033[31m#{I18n.t('thread.thread_not_found', server_id:)}" }

      nil
    else
      server_thread[:thread].kill
      @@servers_threads.delete(server_thread)

      Rails.logger.debug { "\033[31m#{I18n.t('thread.thread_stopped', server_id:)}" }
    end
  end
end
