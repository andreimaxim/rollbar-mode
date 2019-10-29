# frozen_string_literal: true

module Rollbar
  module Mode
    # Rollbar production minor-mode.
    class Production

      class << self

        # :reek:TooManyStatements
        def apply
          Rollbar.configure do |config|
            config.enabled = true
            config.access_token = access_token

            # Override the default values with better ones
            config.populate_empty_backtraces = true
            config.use_async = true

            # Set up the code-related metrics.
            config.code_version = code_version
            config.environment = environment
          end

          warn 'Rollbar: using online service at https://rollbar.com'
        end

        def code_version
          ENV['HEROKU_SLUG_COMMIT']
        end

        def environment
          ENV['HEROKU_APP_NAME']
        end

        def access_token
          ENV['ROLLBAR_ACCESS_TOKEN']
        end

      end

    end
  end
end
