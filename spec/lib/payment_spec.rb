require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'payments/esr_payment'
require 'payments/total_record'
require 'character_conversion'

class Test
  extend DTA::CharacterConversion
end

describe "dta payments" do
  it "should have a dta encoded representation" do
    record = Factory.create_total_record(:data_file_sender_identification => 'ÄÜ2')
    record.to_dta.should == Test.dta_string(record.record)
  end
end