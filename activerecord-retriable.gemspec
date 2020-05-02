require_relative 'lib/activerecord/retriable/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-retriable"
  spec.version       = ActiveRecord::Retriable::VERSION
  spec.authors       = ["João Fernandes"]
  spec.email         = ["joao.fernandes@ist.utl.pt"]

  spec.summary       = "Retry your Active Record transactions."
  spec.homepage      = "https://github.com/jcmfernandes/activerecord-retriable"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties', '>= 5', '< 7'
  spec.add_dependency 'activerecord', '>= 5', '< 7'
  spec.add_dependency 'activesupport', '>= 5', '< 7'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
end
