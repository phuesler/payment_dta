require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dta_file'
require 'esr_payment'

describe DTAFile do
  it "should create a file" do
    path = File.expand_path(File.dirname(__FILE__) + '/../../tmp/payments.dta')
    DTAFile.create(path) do |file|
    end
    File.exist?(path).should be_true
  end
  
  describe DTAFile, "records" do
    before(:each) do
      @path = File.expand_path(File.dirname(__FILE__) + '/../../tmp/payments.dta')
    end
    
    it "should add records to it" do
      payment = Factory.create_esr_payment
      DTAFile.create(@path) do |file|
        file << payment
      end
      File.open(@path).readlines.first.should == payment.record + "\n"
    end
  end
end
