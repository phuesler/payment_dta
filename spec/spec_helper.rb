$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'payment_dta_ch'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
