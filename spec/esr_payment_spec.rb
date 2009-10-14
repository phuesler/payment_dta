require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'esr_payment'

describe "ESR payment" do
  before(:each) do
    @default_attributes = {
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
      ESRPayment.new(@default_attributes).segment1[0,2].should == "01"
    end
    
    it "should have a reference number" do
      ESRPayment.new(@default_attributes.merge(:reference_number => 'ABC0100123478901')).segment1[53,16].should == "ABC0100123478901"
    end
    
    it "should have a debit account without IBAN justified left filled with blanks" do
      ESRPayment.new(@default_attributes.merge(:debit_account_number => '10235678')).segment1[69,24].should == '10235678                '
    end
    
    it "should have a debit account with IBAN" do
      ESRPayment.new(@default_attributes.merge(:debit_account_number => 'CH9300762011623852957')).segment1[69,24].should == 'CH9300762011623852957   '
    end
    
    it "should have a blank debit amount valuta (6 blanks)" do
      ESRPayment.new(@default_attributes).segment1[93,6].should == '      '
    end
    
    it "should have a debit amount currency code" do
     ESRPayment.new(@default_attributes.merge(:debit_amount_currency => 'CHF')).segment1[99,3].should == 'CHF'
    end
    
    it "should have a debit amount justified left filled with blanks" do
      ESRPayment.new(@default_attributes.merge(:debit_amount => '3949.75')).segment1[102,12].should == '3949.75     '
    end
    
    it "should have a reserve field" do
      ESRPayment.new(@default_attributes).segment1[114,14].should == " ".ljust(14) 
    end
    
    it "should have a total length of 128 characters" do
      ESRPayment.new(@default_attributes).segment1.size.should == 128
    end
    
    describe "header" do
      it "should have a total length of 51 characters" do
        ESRPayment.new(@default_attributes).header.size.should == 51
      end

      it "should set a the correct execution date" do
        ESRPayment.new(@default_attributes.merge(:execution_date => "051021")).header[0,6].should == "051021"
      end

      it "should fill the bc number with blanks" do
        ESRPayment.new(@default_attributes).header[6,12].should == "".ljust(12," ")
      end

      it "should fill out a blank sequence number" do
        ESRPayment.new(@default_attributes).header[18,5].should == "00000"
      end

      it "should set the creation date" do
        ESRPayment.new(@default_attributes).header[23,6].should == Date.today.strftime("%y%m%d")
      end

      it "should set the payers clearing number and pad it" do
        ESRPayment.new(@default_attributes.merge(:payers_clearing_number => "254")).header[29,7].should == "2540000"
      end

      it "should set the file identification" do
        ESRPayment.new(@default_attributes.merge(:file_identification => "ABC12")).header[36,5].should == "ABC12"
      end

      it "should should set the record sequence number" do
       ESRPayment.new(@default_attributes.merge(:record_sequence_number => 1)).header[41,5].should == "00001"
      end

      it "should should set the transaction type to 826" do
       ESRPayment.new(@default_attributes).header[46,3].should == "826" 
      end

      it "should set the payment type to 1" do
       ESRPayment.new(@default_attributes).header[49,1].should == "1" 
      end

      it "should set the transaction flag to 0" do
       ESRPayment.new(@default_attributes).header[50,1].should == "0" 
      end
    end

  end
    
  describe ESRPayment, "segment 2" do
    it "should set the segment field to 02" do
      ESRPayment.new(@default_attributes).segment2[0,2].should == "02"
    end
    
    it "should have an issuer address line 1" do
      ESRPayment.new(@default_attributes.merge(:issuer_address_line1 => 'John Doe')).segment2[2,20].should == 'John Doe'.ljust(20)
    end

    it "should have an issuer address line 2" do
      ESRPayment.new(@default_attributes.merge(:issuer_address_line2 => 'Bahnhofstrasse 1')).segment2[22,20].should == 'Bahnhofstrasse 1'.ljust(20)      
    end

    it "should have an issuer address line 3" do
      ESRPayment.new(@default_attributes.merge(:issuer_address_line3 => '8000 Zurich')).segment2[42,20].should == '8000 Zurich'.ljust(20)
    end
    
    it "should have an issuer address line 4" do
      ESRPayment.new(@default_attributes.merge(:issuer_address_line4 => 'Schweiz')).segment2[62,20].should == 'Schweiz'.ljust(20)
    end
    
    it "should have a reserve field" do
      ESRPayment.new(@default_attributes).segment2[82,46].should == ''.ljust(46)
    end
    
    it "should have a length of 128 characters" do
      ESRPayment.new(@default_attributes).segment2.size.should == 128
    end
  end
  
  describe ESRPayment, 'segment 3' do
    it "should set the segment field to 03" do
      ESRPayment.new(@default_attributes).segment3[0,2].should == "03"
    end
    
    it "should have the recipients ESR number" do
      ESRPayment.new(@default_attributes.merge(:recipient_esr_number => '012127029')).segment3[2,12].should == '/C/012127029'
    end
    
    it "should have a recipient address line 1" do
      ESRPayment.new(@default_attributes.merge(:recipient_address_line1 => 'Michael Recipient')).segment3[14,20].should == 'Michael Recipient'.ljust(20)
    end

    it "should have a recipient address line 2" do
      ESRPayment.new(@default_attributes.merge(:recipient_address_line2 => 'Empfaengerstrasse 1')).segment3[34,20].should == 'Empfaengerstrasse 1'.ljust(20)
    end

    it "should have a recipient address line 3" do
      ESRPayment.new(@default_attributes.merge(:recipient_address_line3 => '8640 Rapperswil')).segment3[54,20].should == '8640 Rapperswil'.ljust(20)
    end

    it "should have a recipient address line 4" do
      ESRPayment.new(@default_attributes.merge(:recipient_address_line4 => 'Schweiz')).segment3[74,20].should == 'Schweiz'.ljust(20)
    end
    
    describe "ESR reference number with 9 figure recipient esr number" do
      it "should have an ESR reference number" do
        ESRPayment.new(@default_attributes.merge(:recipient_esr_number => '012127029',:esr_reference_number => '123456789012345678901234567')).segment3[94,27].should == '123456789012345678901234567'
      end
    
      it "should justify right the ESR reference number" do
        ESRPayment.new(@default_attributes.merge(:recipient_esr_number => '12127029',:esr_reference_number => '9876543210123456')).segment3[94,27].should == '000000000009876543210123456'
      end
      
      it "should have an esr reference number check" do
        ESRPayment.new(@default_attributes.merge(:recipient_esr_number => '12127029')).segment3[121,2].should == '  '
      end
    end

    describe "ESR reference number with 5 figure recipient esr number" do
      it "should have an ESR reference number justified left with blanks" do
        ESRPayment.new(@default_attributes.merge(:recipient_esr_number => '10304', :esr_reference_number => '012345678901234')).segment3[94,27].should == '012345678901234'.ljust(27)
      end
      
      it "should have an esr reference number check" do
        ESRPayment.new(@default_attributes.merge(:recipient_esr_number => '10304', :recipient_esr_number_check => '45')).segment3[121,2].should == '45'
      end
    end

    it "should have a reserve field" do
      ESRPayment.new(@default_attributes).segment3[123,5].should == ''.ljust(5)
    end

    it "should have a length of 128 characters" do
      ESRPayment.new(@default_attributes).segment3.size.should == 128
    end
  end
end