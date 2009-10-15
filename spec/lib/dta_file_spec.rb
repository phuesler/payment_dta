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
      path = File.expand_path(File.dirname(__FILE__) + '/../../tmp/payments.dta')
      @record1 = Factory.create_esr_record
      @record2 = Factory.create_esr_record(:debit_amount => '3949.75')
      @dta_file = DTAFile.create(path) do |file|
        file << @record1
        file << @record2
      end
      @file_records = File.open(path).readlines
    end
    
    it "should add all records to it" do
      @dta_file.records.size.should equal(2)
    end
    
    it "should add the records to the file" do
      @file_records.first.should == @record1.record + "\n"
      @file_records[1].should == @record2.record + "\n"      
    end
    
    it "should sort the records by execution date" do
      
    end
  end
end
