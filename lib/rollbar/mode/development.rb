# frozen_string_literal: true

module Rollbar
  module Mode
    # Rollbar development minor mode
    class Development

      class << self

        # :reek:TooManyStatements
        def apply
          Rollbar.reset_notifier!
          Rollbar.notifier = Rollbar::Mode::LocalNotifier.new

          Rollbar.configure do |config|
            config.enabled = false
            config.raise_on_error = true
          end

          warn 'Rollbar: disabled, errors re-raised automatically'
        end

      end

    end
  end
end
