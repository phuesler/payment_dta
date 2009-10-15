require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dta_file'
require 'records/esr_record'

describe DTAFile do
  before(:all) do
    @path = File.expand_path(File.dirname(__FILE__) + '/../../tmp/payments.dta')
  end
  
  it "should create a file" do
    DTAFile.create(@path) do |file|
    end
    File.exist?(@path).should be_true
  end
  
  it "should set the issuer_transaction_number for any record added" do
    file = DTAFile.new(@path, "00123478901")
    file << Factory.create_esr_record
    file.records.first.issuer_transaction_number.should == "00123478901"
  end
  
  describe DTAFile, "file records" do
    before(:each) do
      @record1 = Factory.create_esr_record(:execution_date  => "091022")
      @record2 = Factory.create_esr_record(:execution_date  => "091021",:debit_amount => '3949.75')
      @dta_file = DTAFile.create(@path) do |file|
        file << @record1
        file << @record2
      end
      @file_records = File.open(@path).readlines
    end
    
    it "should add the records to the file" do
      @file_records.should include(@record2.record + "\n")
      @file_records.should include(@record2.record + "\n")
    end    
  end
  
  describe DTAFile, "record sorting" do
    before(:each) do
      @record1 = Factory.create_esr_record(:execution_date  => "091027", :issuer_identification => "AAAAA")
      @record2 = Factory.create_esr_record(:execution_date  => "091026",:issuer_identification => "BBBBB")
      @record3 = Factory.create_esr_record(:execution_date  => "091026",:issuer_identification => "CCCCC")
      @record4 = Factory.create_esr_record(:execution_date  => "091028",:issuer_identification => "AAAAA")
      @dta_file = DTAFile.new(@path)
      @dta_file << @record1
      @dta_file << @record2
      @dta_file << @record3
      @dta_file << @record4
    end

    it "should add all records to it" do
      @dta_file.records.size.should equal(4)
    end
        
    it "should sort the records" do
      @dta_file.records.to_a.should == [@record1, @record2,@record3, @record4].sort
    end    
  end
end
