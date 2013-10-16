require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'payments/special_financial_institution_payment'

describe SpecialFinancialInstitutionPayment do
  it "should have a total length of 640 characters" do
    Factory.create_special_financial_institution_payment.record.size.should == 640
  end
  
  describe 'segment1' do
    it 'should set the segment field to 01' do
      Factory.create_special_financial_institution_payment.segment1[0,2].should == '01'
    end
    
    it 'should have a reference number' do
      Factory.create_special_financial_institution_payment(:issuer_identification => 'ABC01', :transaction_number => '00123478901').segment1[53,16].should == "ABC0100123478901"
    end
    
    it 'should have an account to be debited without IBAN justified left filled with blanks' do
      Factory.create_special_financial_institution_payment(:account_to_be_debited => '10235678').segment1[69,34].should == '10235678'.ljust(34)
    end
    
    it 'should have an account to be debited with IBAN' do
      Factory.create_special_financial_institution_payment(:account_to_be_debited => 'CH9300762011623852957').segment1[69,34].should == 'CH9300762011623852957'.ljust(34)
    end
    
    it 'should have a payment amount value date yymmdd' do
      Factory.create_special_financial_institution_payment(:payment_amount_value_date => '051031').segment1[103,6].should == '051031'
    end
    
    it 'should have a payment amount currency code' do
     Factory.create_special_financial_institution_payment(:payment_amount_currency => 'CHF').segment1[109,3].should == 'CHF'
    end
    
    it 'should have a payment amount justified left filled with blanks' do
      Factory.create_special_financial_institution_payment(:payment_amount => '3949.75').segment1[112,15].should == '3949,75'.ljust(15)
    end
    
    it 'should have a reserve field' do
      Factory.create_special_financial_institution_payment.segment1[127,1].should == ' '.ljust(1) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_special_financial_institution_payment.segment1.size.should == 128
    end
  end
  
  describe 'segment2' do
    it 'should set the segment field to 02' do
      Factory.create_special_financial_institution_payment.segment2[0,2].should == '02'
    end
    
    it 'should set the conversion rate if given' do
      Factory.create_special_financial_institution_payment(:convertion_rate => '0.9543').segment2[2,12].should == '0.9543'.ljust(12)
    end
    
    it 'should have an ordering partys address line 1' do
      Factory.create_special_financial_institution_payment(:ordering_partys_address_line1 => 'John Doe').segment2[14,24].should == 'John Doe'.ljust(24)
    end

    it 'should have an ordering partys address line 2' do
      Factory.create_special_financial_institution_payment(:ordering_partys_address_line2 => 'Bahnhofstrasse 1').segment2[38,24].should == 'Bahnhofstrasse 1'.ljust(24)
    end

    it 'should have an ordering partys address line 3' do
      Factory.create_special_financial_institution_payment(:ordering_partys_address_line3 => '8000 Zurich').segment2[62,24].should == '8000 Zurich'.ljust(24)
    end
    
    it 'should have an ordering partys address line 4' do
      Factory.create_special_financial_institution_payment(:ordering_partys_address_line4 => 'Schweiz').segment2[86,24].should == 'Schweiz'.ljust(24)
    end
    
    it 'should have a reserve field' do
      Factory.create_special_financial_institution_payment.segment2[110,18].should == ' '.ljust(18) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_special_financial_institution_payment.segment2.size.should == 128
    end
  end
  describe 'segment3' do
    it 'should set the segment field to 03' do
      Factory.create_special_financial_institution_payment.segment3[0,2].should == '03'
    end
    
    it 'have an identification bank address' do
      Factory.create_special_financial_institution_payment(:identification_bank_address => 'D').segment3[2,1].should == 'D'
    end
    
    it 'should have the beneficiarys bank account number' do
    Factory.create_special_financial_institution_payment(:beneficiary_institution_bank_account_number =>'111222333').segment3[3,24].should == '/C/111222333'.ljust(24)
    end
    
    describe 'option A' do
      it 'should must contain the 8- or 11-character BIC address (= SWIFT address) of the beneficiarys institution' do
        Factory.create_special_financial_institution_payment(:identification_bank_address => 'A', :beneficiarys_institution_swift_address_ => 'BBBBLLRRNL2').segment3[27,24].should == 'BBBBLLRRNL2'.ljust(24)
      end
      
      it 'should leave lines 3 to 5 blank' do
        Factory.create_special_financial_institution_payment(:identification_bank_address => 'A', :beneficiarys_institution_swift_address_ => 'BBBBLLRRNL2').segment3[51,72].should == ''.ljust(72)
      end
    end
    
    describe 'option D' do
      it 'should have a  address line 1' do
        Factory.create_special_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line1 => 'Michael Recipient').segment3[27,24].should == 'Michael Recipient'.ljust(24)
      end

      it 'should have a beneficiary institution address line 2' do
        Factory.create_special_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line2 => 'Empfaengerstrasse 1').segment3[51,24].should == 'Empfaengerstrasse 1'.ljust(24)
      end

      it 'should have a beneficiary institution address line 3' do
        Factory.create_special_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line3 => '8640 Rapperswil').segment3[75,24].should == '8640 Rapperswil'.ljust(24)
      end

      it 'should have a beneficiary institution address line 4' do
        Factory.create_special_financial_institution_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line4 => 'Schweiz').segment3[99,24].should == 'Schweiz'.ljust(24)
      end
    end
    
    it 'should have a reserve field' do
      Factory.create_special_financial_institution_payment.segment3[123,5].should == ''.ljust(5)
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_special_financial_institution_payment.segment3.size.should == 128
    end
  end
  describe 'segment4' do
    it 'should set the segment field to 04' do
      Factory.create_special_financial_institution_payment.segment4[0,2].should == '04'
    end
    
    it 'should have the beneficiarys bank account number' do
      Factory.create_special_financial_institution_payment(:beneficiary_bank_account_number =>'111222333').segment4[2,24].should == '/C/111222333'.ljust(24)
    end
    
    it 'should have a  address line 1' do
      Factory.create_special_financial_institution_payment(:beneficiary_address_line1 => 'Michael Recipient').segment4[26,24].should == 'Michael Recipient'.ljust(24)
    end

    it 'should have a beneficiary address line 2' do
      Factory.create_special_financial_institution_payment(:beneficiary_address_line2 => 'Empfaengerstrasse 1').segment4[50,24].should == 'Empfaengerstrasse 1'.ljust(24)
    end

    it 'should have a beneficiary address line 3' do
      Factory.create_special_financial_institution_payment(:beneficiary_address_line3 => '8640 Rapperswil').segment4[74,24].should == '8640 Rapperswil'.ljust(24)
    end

    it 'should have a beneficiary address line 4' do
      Factory.create_special_financial_institution_payment(:beneficiary_address_line4 => 'Schweiz').segment4[98,24].should == 'Schweiz'.ljust(24)
    end
    
    it 'should have a reserve field' do
      Factory.create_special_financial_institution_payment.segment4[122,6].should == ''.ljust(6)
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_special_financial_institution_payment.segment4.size.should == 128
    end
  end
  
  describe 'segment5' do
    it 'should set the segment field to 05' do
      Factory.create_special_financial_institution_payment.segment5[0,2].should == '05'
    end
    
    it "should have a beneficiary IBAN number" do
      Factory.create_special_financial_institution_payment(:beneficiary_iban_number => 'CH3808888123456789012').segment5[2,34].should == 'CH3808888123456789012'.ljust(34)
    end
    
    it 'should have a reserve field' do
      Factory.create_special_financial_institution_payment.segment5[36,92].should == ' '.ljust(92) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_special_financial_institution_payment.segment5.size.should == 128
    end
  end
  
  describe 'segment6' do
    it 'should set the segment field to 06' do
      Factory.create_special_financial_institution_payment.segment6[0,2].should == '06'
    end

    it "should have an identification purpose" do
      Factory.create_special_financial_institution_payment(:identification_purpose => 'I', :purpose_structured_reference_number => 'i3or6cev1wog5ez5og8j').segment6[2,1].should == 'I'
    end
    
    describe 'identification purpose is I' do
      it 'should have a structured reference number' do
        Factory.create_special_financial_institution_payment(:identification_purpose => 'I', :purpose_structured_reference_number => 'i3or6cev1wog5ez5og8j').segment6[3,105].should == 'i3or6cev1wog5ez5og8j'.ljust(105)
      end
    end
    
    describe 'identification purpose is U' do
      it 'should have a purpose text line 1' do
        Factory.create_special_financial_institution_payment(:identification_purpose => 'U', :purpose_line_1 => 'LINE 1').segment6[3,35].should == 'LINE 1'.ljust(35)
      end
      
      it 'should have a purpose text line 2' do
        Factory.create_special_financial_institution_payment(:identification_purpose => 'U', :purpose_line_2 => 'LINE 2').segment6[38,35].should == 'LINE 2'.ljust(35)
      end

      it 'should have a purpose text line 3' do
        Factory.create_special_financial_institution_payment(:identification_purpose => 'U', :purpose_line_3 => 'LINE 3').segment6[73,35].should == 'LINE 3'.ljust(35)
      end
    end
    
    it "should have a rule of charge" do
      Factory.create_special_financial_institution_payment(:rule_of_charge => '2').segment6[108,1].should == '2'
    end

    it 'should have a reserve field' do
      Factory.create_special_financial_institution_payment.segment6[114,11].should == ' '.ljust(11)
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_special_financial_institution_payment.segment6.size.should == 128
    end
  end

  describe 'comparison' do
    it "should sort by issuer identification" do
      @record1 = Factory.create_special_financial_institution_payment(:issuer_identification => "AAAAA")
      @record2 = Factory.create_special_financial_institution_payment(:issuer_identification => "BBBBB")
    
      (@record1 < @record2).should be_true
    end
  
    it "should sort by issuers clearing number when issuer identifications are equal" do
      @record1 = Factory.create_special_financial_institution_payment(:issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '253')
      @record2 = Factory.create_special_financial_institution_payment(:issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '254')
    
      (@record1 < @record2).should be_true
    end
  end
end