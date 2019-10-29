# frozen_string_literal: true

module Rollbar
  module Mode
    # Local notifier that re-raises the exceptions
    class LocalNotifier < ::Rollbar::Notifier

      # Normally would send a report to Rollbar.
      #
      #  Accepts any number of arguments. The last String argument will become
      # the message or description of the report. The last Exception argument
      # will become the associated exception for the report. The last hash
      # argument will be used as the extra data for the report.
      #
      # This method is used by code lilke:
      #
      # @example
      #   begin
      #     foo = bar
      #   rescue => e
      #     Rollbar.error(e)
      #   end
      #
      # or:
      #
      # @example
      #   begin
      #     foo = bar
      #    rescue => e
      #      Rollbar.log(e, 'This is a description of the exception')
      #    end
      #
      def log(_level, *args)
        _message, exception, _extra, _context = extract_arguments(args)
        raise(exception) if configuration.raise_on_error && exception
      end

    end
  end
end
