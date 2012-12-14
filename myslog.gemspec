# -*- coding:utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["taka84u9"]
  gem.email         = ["taka84u9@gmail.com"]
  gem.description   = %q{MySQL slow query parser.}
  gem.summary       = %q{MySQL slow query parser.}
  gem.homepage      = "https://github.com/yuku-t/myslog"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "myslog"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.6"
  gem.add_development_dependency "rspec"
end
