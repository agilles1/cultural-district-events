require_relative 'lib/cultural_district_events/version'

Gem::Specification.new do |spec|
  spec.name          = "cultural_district_events"
  spec.version       = CDE::VERSION
  spec.authors       = ["agilles1"]
  spec.email         = ["adam.g.tpt@gmail.com"]

  spec.summary       = %q{Cultural District Event CLI}


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'open_uri_redirections'
  spec.add_dependency 'nokogiri'
  spec.add_development_dependency 'pry'

end
