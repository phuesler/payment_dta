$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib','payment_dta'))
require 'spec'
require 'spec/autorun'
require 'factory'

Spec::Runner.configure do |config|
  
end
