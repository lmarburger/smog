# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "smog/version"

Gem::Specification.new do |s|
  s.name        = "smog"
  s.version     = Smog::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Larry Marburger"]
  s.email       = ["larry@marburger.cc"]
  s.homepage    = "http://github.com/lmarburger/smog"
  s.summary     = %q{Test the CloudApp API from the command line}
  s.description = %q{Smog simply outputs a curl command to use to test the CloudApp API}

  s.add_dependency "main"

  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
