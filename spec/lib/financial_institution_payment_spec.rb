require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'payments/financial_institution_payment'

describe FinancialInstitutionPayment do
  
  it "should have a total length of 768 characters" do
    Factory.create_financial_institution_payment.record.size.should == 768
  end
  
  describe 'segment 1' do
    it 'should set the segment field to 01' do
      Factory.create_financial_institution_payment.segment1[0,2].should == '01'
    end
    
    it 'should have a reference number' do
      Factory.create_financial_institution_payment(:issuer_identification => 'ABC01', :transaction_number => '00123478901').segment1[53,16].should == "ABC0100123478901"
    end
    
    it 'should have an account to be debited without IBAN justified left filled with blanks' do
      Factory.create_financial_institution_payment(:account_to_be_debited => '10235678').segment1[69,24].should == '10235678                '
    end
    
    it 'should have an account to be debited with IBAN' do
      Factory.create_financial_institution_payment(:account_to_be_debited => 'CH9300762011623852957').segment1[69,24].should == 'CH9300762011623852957   '
    end
    
    it 'should have a payment amount value date yymmdd' do
      Factory.create_financial_institution_payment(:payment_amount_value_date => '051031').segment1[93,6].should == '051031'
    end
    
    it 'should have a payment amount currency code' do
     Factory.create_financial_institution_payment(:payment_amount_currency => 'CHF').segment1[99,3].should == 'CHF'
    end
    
    it 'should have a payment amount justified left filled with blanks' do
      Factory.create_financial_institution_payment(:payment_amount => '3949.75').segment1[102,15].should == '3949,75'.ljust(15)
    end
    
    it 'should have a reserve field' do
      Factory.create_financial_institution_payment.segment1[114,11].should == ' '.ljust(11) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_financial_institution_payment.segment1.size.should == 128
    end
  end
  
  describe 'segment 2' do
    it 'should set the segment field to 02' do
      Factory.create_financial_institution_payment.segment2[0,2].should == '02'
    end
    
    it 'should set the conversion rate if given' do
      Factory.create_financial_institution_payment(:convertion_rate => '0.9543').segment2[2,12].should == '0.9543'.ljust(12)
    end
    
    it 'should have an ordering partys address line 1' do
      Factory.create_financial_institution_payment(:ordering_partys_address_line1 => 'John Doe').segment2[14,24].should == 'John Doe'.ljust(24)
    end

    it 'should have an ordering partys address line 2' do
      Factory.create_financial_institution_payment(:ordering_partys_address_line2 => 'Bahnhofstrasse 1').segment2[38,24].should == 'Bahnhofstrasse 1'.ljust(24)
    end

    it 'should have an ordering partys address line 3' do
      Factory.create_financial_institution_payment(:ordering_partys_address_line3 => '8000 Zurich').segment2[62,24].should == '8000 Zurich'.ljust(24)
    end
    
    it 'should have an ordering partys address line 4' do
      Factory.create_financial_institution_payment(:ordering_partys_address_line4 => 'Schweiz').segment2[86,24].should == 'Schweiz'.ljust(24)
    end
    
    it 'should have a reserve field' do
      Factory.create_financial_institution_payment.segment2[82,18].should == ''.ljust(18)
    end
    
    it 'should have a length of 128 characters' do
      Factory.create_financial_institution_payment.segment2.size.should == 128
    end
  end
  
  describe 'segment 3' do
    it 'should set the segment field to 03' do
      Factory.create_financial_institution_payment.segment3[0,2].should == '03'
    end
    
    it 'have an identification bank address' do
      Factory.create_financial_institution_payment(:identification_bank_address => 'D').segment3[2,1].should == 'D'
    end
    
    it 'should have the beneficiarys bank account number' do
    Factory.create_financial_institution_payment(:beneficiary_institution_bank_account_number =>'111222333').segment3[3,24].should == '/C/111222333'.ljust(24)
    end
    
    describe 'option A' do
      it 'should must contain the 8- or 11-character BIC address (= SWIFT address) of the beneficiarys institution' do
        Factory.create_financial_institution_payment(:identification_bank_address => 'A', :beneficiarys_institution_swift_address_ => 'BBBBLLRRNL2').segment3[27,24].should == 'BBBBLLRRNL2'.ljust(24)
      end
      
      it 'should leave lines 3 to 5 blank' do
        Factory.create_financial_institution_payment(:identification_bank_address => 'A', :beneficiarys_institution_swift_address_ => 'BBBBLLRRNL2').segment3[51,72].should == ''.ljust(72)
      end
    end
    
    describe 'option D' do
      it 'should have a  address line 1' do
        Factory.create_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line1 => 'Michael Recipient').segment3[27,24].should == 'Michael Recipient'.ljust(24)
      end

      it 'should have a beneficiary institution address line 2' do
        Factory.create_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line2 => 'Empfaengerstrasse 1').segment3[51,24].should == 'Empfaengerstrasse 1'.ljust(24)
      end

      it 'should have a beneficiary institution address line 3' do
        Factory.create_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line3 => '8640 Rapperswil').segment3[75,24].should == '8640 Rapperswil'.ljust(24)
      end

      it 'should have a beneficiary institution address line 4' do
        Factory.create_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line4 => 'Schweiz').segment3[99,24].should == 'Schweiz'.ljust(24)
      end
    end
    
    it 'should have a reserve field' do
      Factory.create_financial_institution_payment.segment3[123,5].should == ''.ljust(5)
    end

    it 'should have a length of 128 characters' do
      Factory.create_financial_institution_payment.segment3.size.should == 128
    end
  end
  
  describe 'segment 4' do
    it 'should set the segment field to 03' do
      Factory.create_financial_institution_payment.segment4[0,2].should == '04'
    end
        
    it 'should have the beneficiarys bank account number' do
      Factory.create_financial_institution_payment(:beneficiary_bank_account_number =>'111222333').segment4[2,24].should == '/C/111222333'.ljust(24)
    end
    
    it 'should have a  address line 1' do
      Factory.create_financial_institution_payment(:beneficiary_address_line1 => 'Michael Recipient').segment4[26,24].should == 'Michael Recipient'.ljust(24)
    end

    it 'should have a beneficiary address line 2' do
      Factory.create_financial_institution_payment(:beneficiary_address_line2 => 'Empfaengerstrasse 1').segment4[50,24].should == 'Empfaengerstrasse 1'.ljust(24)
    end

    it 'should have a beneficiary address line 3' do
      Factory.create_financial_institution_payment(:beneficiary_address_line3 => '8640 Rapperswil').segment4[74,24].should == '8640 Rapperswil'.ljust(24)
    end

    it 'should have a beneficiary address line 4' do
      Factory.create_financial_institution_payment(:beneficiary_address_line4 => 'Schweiz').segment4[98,24].should == 'Schweiz'.ljust(24)
    end

    it "should have a reserve field" do
      Factory.create_financial_institution_payment.segment4[122,6].should == ''.ljust(6)
    end

    it 'should have a length of 128 characters' do
      Factory.create_financial_institution_payment.segment4.size.should == 128
    end
  end
  
  describe 'segment 5' do
    it 'should set the segment field to 05' do
      Factory.create_financial_institution_payment.segment5[0,2].should == '05'
    end
    
    it "should have a reason for payment message line 1" do
      Factory.create_financial_institution_payment(:reason_for_payment_message_line1 => 'LINE1').segment5[2,30].should == 'LINE1'.ljust(30)
    end
    
    it "should have a reason for payment message line 2" do
      Factory.create_financial_institution_payment(:reason_for_payment_message_line2 => 'LINE2').segment5[32,30].should == 'LINE2'.ljust(30)
    end
    
    it "should have a reason for payment message line 3" do
      Factory.create_financial_institution_payment(:reason_for_payment_message_line3 => 'LINE3').segment5[62,30].should == 'LINE3'.ljust(30)
    end
    
    it "should have a reason for payment message line 4" do
      Factory.create_financial_institution_payment(:reason_for_payment_message_line4 => 'LINE4').segment5[92,30].should == 'LINE4'.ljust(30)
    end

    it 'should have a reserve field' do
      Factory.create_financial_institution_payment.segment5[122,6].should == ' '.ljust(6)
    end
    
    it 'should have a length of 128 characters' do
      Factory.create_financial_institution_payment.segment5.size.should == 128
    end
  end
  
  describe 'segment 6' do
    it 'should set the segment field to 06' do
      Factory.create_financial_institution_payment.segment6[0,2].should == '06'
    end
    
    it "should have bank payment instructions" do
      Factory.create_financial_institution_payment(:bank_payment_instructions => "CHG/OUR").segment6[2,120].should == 'CHG/OUR'.ljust(120)
    end
    
    it 'should have a reserve field' do
      Factory.create_financial_institution_payment.segment6[122,6].should == ' '.ljust(6)
    end
    
    it 'should have a length of 128 characters' do
      Factory.create_financial_institution_payment.segment6.size.should == 128
    end
  end
  
  describe 'comparison' do
    it "should sort by issuer identification" do
      @record1 = Factory.create_financial_institution_payment(:issuer_identification => "AAAAA")
      @record2 = Factory.create_financial_institution_payment(:issuer_identification => "BBBBB")
      
      (@record1 < @record2).should be_true
    end
    
    it "should sort by issuers clearing number when issuer identifications are equal" do
      @record1 = Factory.create_financial_institution_payment( :issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '253')
      @record2 = Factory.create_financial_institution_payment(:issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '254')
      
      (@record1 < @record2).should be_true
    end
  end
end
