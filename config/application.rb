require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Feedex
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Singapore'

    config.assets.enabled = true

    # config.assets.precompile += ['borderMenu.js', 'classie.js', 'idangerous.swiper-2.1.min.js', 'jquery.js', 'modernizr.custom.js', 'demo.css', 'icons.css', 'idangerous.swiper.css', 'login-grid.css', 'login.css', 'normalize.css', 'signup-grid.css', 'signup.css', 'signup_success-grid.css', 'signup_success.css', 'standardize.css', 'style5.css', 'stylemain.css']
    config.assets.precompile += [ "two/demo.css" ]
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
