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

    config.generators.system_tests = nil
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.after_initialize do
      Rails.application.reload_routes!
      $servers_threads = [] # rubocop :disable Style/GlobalVars
      next unless Server.table_exists?

      servers = Server.all
      servers&.each do |server|
        server.ready_to_polling! if server.may_ready_to_polling?
      end
    end
  end
end
