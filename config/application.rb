# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BoomboxWeb
  ##
  # The application.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Apply Rubocop's unsafe autocorrect to newly generated files.
    config.generators.after_generate do |files|
      rb_files = files.select(&/\.(?:rb|jbuilder)\z/.method(:match?))
      system("bundle exec rubocop -A --fail-level=E #{rb_files.shelljoin}",
             exception: true)
    end
  end
end
