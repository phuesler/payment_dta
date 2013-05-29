require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib','payment_dta'))
require 'rspec'
require 'rspec/autorun'
require 'factory'

RSpec.configure do |config|
end
