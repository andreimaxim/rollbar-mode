# frozen_string_literal: true

require 'rollbar'

require 'rollbar/mode/local_notifier'
require 'rollbar/mode/production'
require 'rollbar/mode/development'

require 'rollbar/mode/version'

module Rollbar
  # Minor mode for Rollbar
  module Mode

    def self.apply
      if Rollbar::Mode.production?
        Rollbar::Mode::Production.apply
      else
        Rollbar::Mode::Development.apply
      end
    end

    def self.production?
      Rollbar::Mode::Production.access_token ||
        Rollbar.configuration.enabled
    end

    # Determine if the current environment is a Heroku dyno based on the
    # dyno metadata.
    #
    # See:
    #
    # https://devcenter.heroku.com/articles/dyno-metadata
    def self.heroku?
      ENV.key?('HEROKU_SLUG_COMMIT') &&
        ENV.key?('HEROKU_APP_NAME')
    end

  end
end

Rollbar::Mode.apply
