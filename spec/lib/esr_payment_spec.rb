require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'payments/esr_payment'

describe 'ESRPayment' do
  it "should have a total length of 384 characters" do
    Factory.create_esr_payment.record.size.should == 384
  end
  
  describe ESRPayment, 'segment 1' do
    it 'should set the segment field to 01' do
      Factory.create_esr_payment.segment1[0,2].should == '01'
    end
    
    it 'should have a reference number' do
      Factory.create_esr_payment(:issuer_identification => 'ABC01', :transaction_number => '00123478901').segment1[53,16].should == 'ABC0100123478901'
    end
    
    it 'should have an account to be debited without IBAN justified left filled with blanks' do
      Factory.create_esr_payment(:account_to_be_debited => '10235678').segment1[69,24].should == '10235678                '
    end
    
    it 'should have an account to be debited with IBAN' do
      Factory.create_esr_payment(:account_to_be_debited => 'CH9300762011623852957').segment1[69,24].should == 'CH9300762011623852957   '
    end
    
    it 'should have a blank payment amount valuta (6 blanks)' do
      Factory.create_esr_payment.segment1[93,6].should == '      '
    end
    
    it 'should have a payment amount currency code' do
     Factory.create_esr_payment(:payment_amount_currency => 'CHF').segment1[99,3].should == 'CHF'
    end
    
    it 'should have a payment amount justified left filled with blanks' do
      Factory.create_esr_payment(:payment_amount => '3949.75').segment1[102,12].should == '3949,75     '
    end
    
    it 'should have a reserve field' do
      Factory.create_esr_payment.segment1[114,14].should == ' '.ljust(14) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_esr_payment.segment1.size.should == 128
    end
  end
    
  describe ESRPayment, 'segment 2' do
    it 'should set the segment field to 02' do
      Factory.create_esr_payment.segment2[0,2].should == '02'
    end
    
    it 'should have an ordering partys address line 1' do
      Factory.create_esr_payment(:ordering_partys_address_line1 => 'John Doe').segment2[2,20].should == 'John Doe'.ljust(20)
    end

    it 'should have an ordering partys address line 2' do
      Factory.create_esr_payment(:ordering_partys_address_line2 => 'Bahnhofstrasse 1').segment2[22,20].should == 'Bahnhofstrasse 1'.ljust(20)      
    end

    it 'should have an ordering partys address line 3' do
      Factory.create_esr_payment(:ordering_partys_address_line3 => '8000 Zurich').segment2[42,20].should == '8000 Zurich'.ljust(20)
    end
    
    it 'should have an ordering partys address line 4' do
      Factory.create_esr_payment(:ordering_partys_address_line4 => 'Schweiz').segment2[62,20].should == 'Schweiz'.ljust(20)
    end
    
    it 'should have a reserve field' do
      Factory.create_esr_payment.segment2[82,46].should == ''.ljust(46)
    end
    
    it 'should have a length of 128 characters' do
      Factory.create_esr_payment.segment2.size.should == 128
    end
  end
  
  describe ESRPayment, 'segment 3' do
    it 'should set the segment field to 03' do
      Factory.create_esr_payment.segment3[0,2].should == '03'
    end
    
    it 'should have the beneficiarys ESR party number' do
      Factory.create_esr_payment(:beneficiarys_esr_party_number => '012127029').segment3[2,12].should == '/C/012127029'
    end
    
    it 'should have a beneficiary address line 1' do
      Factory.create_esr_payment(:beneficiary_address_line1 => 'Michael Recipient').segment3[14,20].should == 'Michael Recipient'.ljust(20)
    end

    it 'should have a beneficiary address line 2' do
      Factory.create_esr_payment(:beneficiary_address_line2 => 'Empfaengerstrasse 1').segment3[34,20].should == 'Empfaengerstrasse 1'.ljust(20)
    end

    it 'should have a beneficiary address line 3' do
      Factory.create_esr_payment(:beneficiary_address_line3 => '8640 Rapperswil').segment3[54,20].should == '8640 Rapperswil'.ljust(20)
    end

    it 'should have a beneficiary address line 4' do
      Factory.create_esr_payment(:beneficiary_address_line4 => 'Schweiz').segment3[74,20].should == 'Schweiz'.ljust(20)
    end
    
    describe 'ESR reference number with 9 figure beneficiary esr number' do
      it 'should have an ESR reference number' do
        Factory.create_esr_payment(:beneficiarys_esr_party_number => '012127029',:reason_for_payment_esr_reference_number => '123456789012345678901234567').segment3[94,27].should == '123456789012345678901234567'
      end
    
      it 'should justify right the ESR reference number' do
        Factory.create_esr_payment(:beneficiarys_esr_party_number => '12127029',:reason_for_payment_esr_reference_number => '9876543210123456').segment3[94,27].should == '000000000009876543210123456'
      end
      
      it 'should have an esr reference number check' do
        Factory.create_esr_payment(:beneficiarys_esr_party_number => '12127029').segment3[121,2].should == '  '
      end
    end

    describe 'ESR reference number with 5 figure beneficiary esr number' do
      it 'should have an ESR reference number justified left with blanks' do
        Factory.create_esr_payment(:beneficiarys_esr_party_number => '10304', :reason_for_payment_esr_reference_number => '012345678901234').segment3[94,27].should == '012345678901234'.ljust(27)
      end
      
      it 'should have an esr reference number check' do
        Factory.create_esr_payment(:beneficiarys_esr_party_number => '10304', :beneficiarys_esr_party_number_check => '45').segment3[121,2].should == '45'
      end
    end

    it 'should have a reserve field' do
      Factory.create_esr_payment.segment3[123,5].should == ''.ljust(5)
    end

    it 'should have a length of 128 characters' do
      Factory.create_esr_payment.segment3.size.should == 128
    end
  end
  
  describe ESRPayment, "comparison" do
    it "should sort by execution date ascending" do
      @record1 = Factory.create_esr_payment(:requested_processing_date  => "091026")
      @record2 = Factory.create_esr_payment(:requested_processing_date  => "091027")
      
      (@record1 < @record2).should be_true
    end
    
    it "should sort by issuer identification when the execution date is equal" do
      @record1 = Factory.create_esr_payment(:requested_processing_date  => "091026", :issuer_identification => "AAAAA")
      @record2 = Factory.create_esr_payment(:requested_processing_date  => "091026",:issuer_identification => "BBBBB")
      
      (@record1 < @record2).should be_true
    end
    
    it "should sort by issuers clearing number when execution date and issuer identification are equal" do
      @record1 = Factory.create_esr_payment(:requested_processing_date  => "091026", :issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '253')
      @record2 = Factory.create_esr_payment(:requested_processing_date  => "091026",:issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '254')
      
      (@record1 < @record2).should be_true
    end
  end
end
