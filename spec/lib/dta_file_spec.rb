require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dta_file'
require 'payments/esr_payment'

describe DTAFile do
  before(:all) do
    @path = File.expand_path(File.dirname(__FILE__) + '/../../tmp/payments.dta')
  end
  
  it "should create a file" do
    DTAFile.create(@path) do |file|
      file << Factory.create_esr_payment
    end
    File.exist?(@path).should be_true
  end
  
  it "should set the transaction_number for any record added" do
    file = DTAFile.new(@path, "00123478901")
    file << Factory.create_esr_payment
    file.records.first.transaction_number.should == "00123478901"
  end
  
  it "should set the transaction number for any record added" do
    file = DTAFile.new(@path)
    file << Factory.create_esr_payment
    file << Factory.create_esr_payment

    file.records.to_a.first.entry_sequence_number.should == "00001"
    file.records.to_a[1].entry_sequence_number.should == "00002"
  end
  
  it "should calculate the total amount" do
    file = DTAFile.new(@path)
    file << Factory.create_esr_payment(:payment_amount => 420.50)
    file << Factory.create_esr_payment(:payment_amount => 320.20)
    file.total.should == (420.50 + 320.20)
  end
  
  describe DTAFile, "file records" do
    before(:each) do
      @record1 = Factory.create_esr_payment(:payment_amount => 2222.22)
      @record2 = Factory.create_esr_payment(:payment_amount => 4444.44)
      @dta_file = DTAFile.create(@path) do |file|
        file << @record1
        file << @record2
      end
      @file_records = File.open(@path).readlines
    end
    
    it "should add the records to the file in dta format" do
      @file_records.should include(@record2.to_dta + "\n")
      @file_records.should include(@record2.to_dta + "\n")
    end
    
    it "should add a total record" do
      @file_records.last.should include(Factory.create_total_record(
        :entry_sequence_number => 3, :total_amount => 6666.66).to_dta)
    end

    describe '#dta_string' do
      it 'equals file contents' do
        @dta_file.dta_string.size.should == IO.read(@path).size
      end
    end
  end
  
  describe DTAFile, "record sorting" do
    before(:each) do
      @record1 = Factory.create_esr_payment(:requested_processing_date  => "091027", :issuer_identification => "AAAAA")
      @record2 = Factory.create_esr_payment(:requested_processing_date  => "091026",:issuer_identification => "BBBBB")
      @record3 = Factory.create_esr_payment(:requested_processing_date  => "091026",:issuer_identification => "CCCCC")
      @record4 = Factory.create_esr_payment(:requested_processing_date  => "091028",:issuer_identification => "AAAAA")
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
