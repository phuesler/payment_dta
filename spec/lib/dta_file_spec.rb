require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dta_file'
require 'records/esr_record'

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
      record = Factory.create_esr_record
      DTAFile.create(@path) do |file|
        file << record
      end
      File.open(@path).readlines.first.should == record.record + "\n"
    end
  end
end
