require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsSandboxEnogineerCom
  class Application < Rails::Application
    config.autoload_paths += %W(
      #{config.root}/app/callbacks
      #{config.root}/app/decorators
      #{config.root}/app/factories
      #{config.root}/app/forms
      #{config.root}/app/observers
      #{config.root}/app/parameters
      #{config.root}/app/presenters
      #{config.root}/app/queries
      #{config.root}/app/services
      #{config.root}/app/validators
      #{config.root}/app/values
      #{config.root}/lib
    )

    config.active_record.observers =
      Dir.
        glob('app/observers/**/*_observer.rb').
        map { |path| path.split(/\//)[2..-1].join('/').gsub(/\.rb/, '') }

    config.paths.add 'app/api', glob: '**/*.rb'
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    I18n.enforce_available_locales = true
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.i18n.locale = :ja

    config.action_controller.default_url_options = {trailing_slash: true}

    config.cache_store = YAML.load(ERB.new(File.read(config.root + 'config/cache_store.yml')).result)[Rails.env]

    config.action_view.field_error_proc = proc { |html_tag, _| html_tag }

    mailer_file = config.root + 'config/mailer.yml'
    if File.exists?(mailer_file)
      mailer = YAML.load(ERB.new(File.read()).result)[Rails.env]

      config.action_mailer.default_url_options = mailer[:default_url_options]

      config.action_mailer.delivery_method = mailer[:delivery_method]

      config.action_mailer.smtp_settings = mailer[:smtp_settings]
    end
  end
end
