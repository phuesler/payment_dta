require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'esr_payment'

describe "ESR payment" do
  before(:each) do
    @default_attriburtes = {
      :file_identification => "ABC12",
      :sequence_number => 1,
      :payers_clearing_number => "254",
      :reference_number => 'ABC0100123478901',
      :debit_account_number => '10235678',
      :debit_amount_currency => 'CHF',
      :debit_amount => '3949.75'
    }
  end
  describe ESRPayment, "segment 1" do
    it "should set the segment field to 01" do
      ESRPayment.new(@default_attriburtes).segment1[0,2].should == "01"
    end
    
    it "should have a reference number" do
      ESRPayment.new(@default_attriburtes.merge(:reference_number => 'ABC0100123478901')).segment1[53,16].should == "ABC0100123478901"
    end
    
    it "should have a debit account without IBAN justified left filled with blanks" do
      ESRPayment.new(@default_attriburtes.merge(:debit_account_number => '10235678')).segment1[69,24].should == '10235678                '
    end
    
    it "should have a debit account with IBAN" do
      ESRPayment.new(@default_attriburtes.merge(:debit_account_number => 'CH9300762011623852957')).segment1[69,24].should == 'CH9300762011623852957   '
    end
    
    it "should have a blank debit amount valuta (6 blanks)" do
      ESRPayment.new(@default_attriburtes).segment1[93,6].should == '      '
    end
    
    it "should have a debit amount currency code" do
     ESRPayment.new(@default_attriburtes.merge(:debit_amount_currency => 'CHF')).segment1[99,3].should == 'CHF'
    end
    
    it "should have a debit amount justified left filled with blanks" do
      ESRPayment.new(@default_attriburtes.merge(:debit_amount => '3949.75')).segment1[102,12].should == '3949.75     '
    end
    
    it "should have a reserve field" do
      ESRPayment.new(@default_attriburtes).segment1[114,14].should == " ".ljust(14) 
    end
    
    it "should have a total length of 128 characters" do
      ESRPayment.new(@default_attriburtes).segment1.size.should == 128
    end
    
    describe "header" do
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
    
  describe ESRPayment, "segment 2" do
    it "should set the segment field to 02" do
      ESRPayment.new(@default_attriburtes).segment2[0,2].should == "02"
    end
    
    it "should have an issuer address line 1" do
      ESRPayment.new(@default_attriburtes.merge(:issuer_address_line1 => 'John Doe')).segment2[2,20].should == 'John Doe'.ljust(20)
    end

    it "should have an issuer address line 2" do
      ESRPayment.new(@default_attriburtes.merge(:issuer_address_line2 => 'Bahnhofstrasse 1')).segment2[22,20].should == 'Bahnhofstrasse 1'.ljust(20)      
    end

    it "should have an issuer address line 3" do
      ESRPayment.new(@default_attriburtes.merge(:issuer_address_line3 => '8000 Zurich')).segment2[42,20].should == '8000 Zurich'.ljust(20)
    end
    
    it "should have an issuer address line 4" do
      ESRPayment.new(@default_attriburtes.merge(:issuer_address_line4 => 'Schweiz')).segment2[62,20].should == 'Schweiz'.ljust(20)
    end
    
    it "should have a reserve field" do
      ESRPayment.new(@default_attriburtes).segment2[82,46].should == ''.ljust(46)
    end
    
    it "should have a length of 128 characters" do
      ESRPayment.new(@default_attriburtes).segment2.size.should == 128
    end
  end
end