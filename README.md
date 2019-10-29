# Rollbar::Mode

The idea behind `Rollbar::Mode` is inspired from the [Emacs major and minor][1]
modes, which alter the behaviour of the editor in certain cases. This is
the equivalent of a "minor mode", which alters the way Rollbar integrates
with your code:

* In development it automatically re-raises exceptions logged with Rollbar
* In production it alters some default values for better integration with Heroku

[1]: https://www.gnu.org/software/emacs/manual/html_node/emacs/Modes.html


### Development mode

In development (i.e. when the Rollbar token is not set), the reporter will
not send errors to Rollbar but re-raise them, allowing the following code
pattern to work well both in development and in production:

``` ruby
def find(id)
  user = method_that_could_raise_exception(id)
rescue StandardError => exception
  Rollbar.error(exception)

  nil
end
```

As of v2.22 of the gem, Rollbar has a setting called `raise_on_error` but will
only work if Rollbar believes it's enabled (the access token is enabled). See
the early `return` in the code snippet below, taken from
`Rollbar::Notifier#log`:


``` ruby
def log(level, *args)
  return 'disabled' unless enabled?

  message, exception, extra, context = extract_arguments(args)
  use_exception_level_filters = use_exception_level_filters?(extra)

  return 'ignored' if ignored?(exception, use_exception_level_filters)

  begin
    status = call_before_process(:level => level,
                                 :exception => exception,
                                 :message => message,
                                 :extra => extra)
    return 'ignored' if status == 'ignored'
  rescue Rollbar::Ignore
    return 'ignored'
  end

  level = lookup_exception_level(level, exception,
                                 use_exception_level_filters)

  ret = report_with_rescue(level, message, exception, extra, context)

  raise(exception) if configuration.raise_on_error && exception

  ret
end
```

If the Rollbar access token is not availble _and_ the `raise_on_errror` setting
is set to `true`, this gem will monkeypatch the `log` method described above
to side-steps the error delivery mechanism and automatically re-raise the
exception.

In order to make sure that the gem only affects your code in development, you
can enable it only in the Bundler `development` group:

``` ruby
group :development do
  gem 'rollbar-mode'
end
```


### Production mode

Rollbar has several configuration options that help with error reporting, like:

* `code_version` for linking stack traces to GitHub (SemVer, git SHA)
* `environment` which defaults to "unspecified"
* `populate_empty_backtraces` for manually initialized exceptions
* `use_async` for reporting errors using either `girl_friday` or threading

`Rollbar::Mode` will alter the default configuration for Rollbar to these
values:

* `code_version` will be set to the value of `HEROKU_SLUG_COMMIT` if available
* `environment` will be set to the value of `HEROKU_APP_NAME`, if available
* `populate_empty_backtraces` will be set to `true` (normal default is `false`)
* `use_async` will be set to `true` (normal default is `false`)

The `HEROKU_*` environment variables are provided by the [Dyno Metadata][2]
feature and has to be enabled manually.

[2]: https://devcenter.heroku.com/articles/dyno-metadata

If you do not want these changes, make sure the gem is in the development
group.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andreimaxim/rollbar-mode.
