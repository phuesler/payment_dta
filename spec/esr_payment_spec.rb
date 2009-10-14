require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'esr_payment'

describe "ESR payment" do
  before(:each) do
    @default_attriburtes = {
      :file_identification => "ABC12",
      :sequence_number => 1,
      :payers_clearing_number => "254"
    }
  end
  describe ESRPayment, "record" do
    it "should set the segment field to 01" do
      ESRPayment.new(@default_attriburtes).segment[0,2].should == "01"
    end
  end
  
  describe ESRPayment, "header" do
    it "should have a total length of 51 characters" do
      ESRPayment.new(@default_attriburtes).header.size.should == 51
    end

    it "should set a the correct execution date" do
      ESRPayment.new(@default_attriburtes.merge(:execution_date => "051021")).header[0,6].should == "051021"
    end

    it "should fill the bc number with blanks" do
      ESRPayment.new(@default_attriburtes).header[6,12].should == "".ljust(12," ")
    end

    it "should fill out a blank sequence number" do
      ESRPayment.new(@default_attriburtes).header[18,5].should == "00000"
    end

    it "should set the creation date" do
      ESRPayment.new(@default_attriburtes).header[23,6].should == Date.today.strftime("%y%m%d")
    end

    it "should set the payers clearing number and pad it" do
      ESRPayment.new(@default_attriburtes.merge(:payers_clearing_number => "254")).header[29,7].should == "2540000"
    end

    it "should set the file identification" do
      ESRPayment.new(@default_attriburtes.merge(:file_identification => "ABC12")).header[36,5].should == "ABC12"
    end

    it "should should set the record sequence number" do
     ESRPayment.new(@default_attriburtes.merge(:record_sequence_number => 1)).header[41,5].should == "00001"
    end

    it "should should set the transaction type to 826" do
     ESRPayment.new(@default_attriburtes).header[46,3].should == "826" 
    end

    it "should set the payment type to 1" do
     ESRPayment.new(@default_attriburtes).header[49,1].should == "1" 
    end

    it "should set the transaction flag to 0" do
     ESRPayment.new(@default_attriburtes).header[50,1].should == "0" 
    end
  end  
end