# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ArmstrongWebServer
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.available_locales = %i[en ru]
    config.i18n.default_locale = :ru

    config.after_initialize do
      next unless Server.table_exists?

      servers = Server.all
      servers&.each do |server|
        server.ready_to_polling! if server.may_ready_to_polling?
      end
    end
  end
end
