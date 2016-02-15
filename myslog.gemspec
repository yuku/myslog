Gem::Specification.new do |spec|
  spec.name          = "myslog"
  spec.version       = "0.1.0"
  spec.authors       = ["taka84u9"]
  spec.email         = ["taka84u9@gmail.com"]
  spec.summary       = "MySQL slow query parser."
  spec.description   = "MySQL slow query parser."
  spec.homepage      = "https://github.com/yuku-t/myslog"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
