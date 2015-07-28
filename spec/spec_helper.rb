require "coveralls"
Coveralls.wear!

require "myslog"

RSpec.configure do |config|
  config.color = true
  config.run_all_when_everything_filtered = true
end
