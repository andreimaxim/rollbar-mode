# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rollbar/mode/version'

Gem::Specification.new do |spec|
  spec.name          = 'rollbar-mode'
  spec.version       = Rollbar::Mode::VERSION
  spec.authors       = 'Andrei Maxim'
  spec.email         = 'andrei@andreimaxim.ro'

  spec.summary       = 'Add a Rollbar minor mode to your environment'
  spec.homepage      = 'https://github.com/andreimaxim/rollbar-mode'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rollbar', '~> 2.22'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
