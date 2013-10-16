require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'payments/iban_payment'

describe IBANPayment do
  it "should have a total length of 640 characters" do
    Factory.create_iban_payment.record.size.should == 640
  end
  
  describe 'segment1' do
    it 'should set the segment field to 01' do
      Factory.create_iban_payment.segment1[0,2].should == '01'
    end
    
    it 'should have a reference number' do
      Factory.create_iban_payment(:issuer_identification => 'ABC01', :transaction_number => '00123478901').segment1[53,16].should == "ABC0100123478901"
    end
    
    it 'should have an account to be debited without IBAN justified left filled with blanks' do
      Factory.create_iban_payment(:account_to_be_debited => '10235678').segment1[69,24].should == '10235678'.ljust(24)
    end
    
    it 'should have an account to be debited with IBAN' do
      Factory.create_iban_payment(:account_to_be_debited => 'CH9300762011623852957').segment1[69,24].should == 'CH9300762011623852957   '
    end
    
    it 'should have a payment amount value date yymmdd' do
      Factory.create_iban_payment(:payment_amount_value_date => '051031').segment1[93,6].should == '051031'
    end
    
    it 'should have a payment amount currency code' do
     Factory.create_iban_payment(:payment_amount_currency => 'USD').segment1[99,3].should == 'USD'
    end
    
    it 'should have a payment amount justified left filled with blanks' do
      Factory.create_iban_payment(:payment_amount => '3949.75').segment1[102,15].should == '3949,75'.ljust(15)
    end
    
    it 'should have a reserve field' do
      Factory.create_iban_payment.segment1[117,11].should == ''.ljust(11) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_iban_payment.segment1.size.should == 128
    end
  end
  describe 'segment2' do
    it 'should set the segment field to 02' do
      Factory.create_iban_payment.segment2[0,2].should == '02'
    end
    
    it 'should set the conversion rate if given' do
      Factory.create_iban_payment(:convertion_rate => '0.9543').segment2[2,12].should == '0.9543'.ljust(12)
    end
    
    it 'should have an ordering partys address line 1' do
      Factory.create_iban_payment(:ordering_partys_address_line1 => 'John Doe').segment2[14,35].should == 'John Doe'.ljust(35)
    end

    it 'should have an ordering partys address line 2' do
      Factory.create_iban_payment(:ordering_partys_address_line2 => 'Bahnhofstrasse 1').segment2[49,35].should == 'Bahnhofstrasse 1'.ljust(35)
    end

    it 'should have an ordering partys address line 3' do
      Factory.create_iban_payment(:ordering_partys_address_line3 => '8000 Zurich').segment2[84,35].should == '8000 Zurich'.ljust(35)
    end
    
    it 'should have a reserve field' do
      Factory.create_iban_payment.segment2[114,9].should == ' '.ljust(9) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_iban_payment.segment2.size.should == 128
    end
  end
  
  describe 'segment3' do
    it 'should set the segment field to 03' do
      Factory.create_iban_payment.segment3[0,2].should == '03'
    end
    
    it 'have an identification bank address' do
      Factory.create_iban_payment(:identification_bank_address => 'D').segment3[2,1].should == 'D'
    end
    
    describe 'option A' do
      it 'should must contain the 8- or 11-character BIC address (= SWIFT address) of the beneficiarys institution' do
        Factory.create_iban_payment(:identification_bank_address => 'A', :beneficiarys_institution_swift_address_ => 'BBBBLLRRNL2').segment3[3,35].should == 'BBBBLLRRNL2'.ljust(35)
      end
      
      it 'should leave the next line blank' do
        Factory.create_iban_payment(:identification_bank_address => 'A', :beneficiarys_institution_swift_address_ => 'BBBBLLRRNL2').segment3[38,35].should == ''.ljust(35)
      end
    end
    
    describe 'option D' do
      it 'should have an address line 1' do
        Factory.create_iban_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line1 => 'SPARKASSE OBERSEE').segment3[3,35].should == 'SPARKASSE OBERSEE'.ljust(35)
      end

      it 'should have a beneficiary institution address line 2' do
        Factory.create_iban_payment(:identification_bank_address => 'D',:beneficiary_institution_address_line2 => 'ANYWHERE').segment3[38,35].should == 'ANYWHERE'.ljust(35)
      end
    end
    
    it "should have a beneficiary IBAN number" do
      Factory.create_iban_payment(:beneficiary_iban_number => 'CH3808888123456789012').segment3[73,34].should == 'CH3808888123456789012'.ljust(34)
    end
    
    it 'should have a reserve field' do
      Factory.create_iban_payment.segment3[107,21].should == ' '.ljust(21) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_iban_payment.segment3.size.should == 128
    end
  end
  
  describe 'segment4' do
    it 'should set the segment field to 04' do
      Factory.create_iban_payment.segment4[0,2].should == '04'
    end
    
    it 'should have a  address line 1' do
      Factory.create_iban_payment(:beneficiary_address_line1 => 'Michael Recipient').segment4[2,35].should == 'Michael Recipient'.ljust(35)
    end

    it 'should have a beneficiary address line 2' do
      Factory.create_iban_payment(:beneficiary_address_line2 => 'Empfaengerstrasse 1').segment4[37,35].should == 'Empfaengerstrasse 1'.ljust(35)
    end

    it 'should have a beneficiary address line 3' do
      Factory.create_iban_payment(:beneficiary_address_line3 => '8640 Rapperswil').segment4[72,35].should == '8640 Rapperswil'.ljust(35)
    end
    
    it 'should have a reserve field' do
      Factory.create_iban_payment.segment4[107,21].should == ' '.ljust(21)
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_iban_payment.segment4.size.should == 128
    end
  end
  
  describe 'segment5' do
    it 'should set the segment field to 05' do
      Factory.create_iban_payment.segment5[0,2].should == '05'
    end
    
    it "should have an identification purpose" do
      Factory.create_iban_payment(:identification_purpose => 'I', :purpose_structured_reference_number => 'i3or6cev1wog5ez5og8j').segment5[2,1].should == 'I'
    end
    
    describe 'identification purpose is I' do
      it 'should have a structured reference number' do
        Factory.create_iban_payment(:identification_purpose => 'I', :purpose_structured_reference_number => 'i3or6cev1wog5ez5og8j').segment5[3,105].should == 'i3or6cev1wog5ez5og8j'.ljust(105)
      end
    end
    
    describe 'identification purpose is U' do
      it 'should have a purpose text line 1' do
        Factory.create_iban_payment(:identification_purpose => 'U', :purpose_line_1 => 'LINE 1').segment5[3,35].should == 'LINE 1'.ljust(35)
      end
      
      it 'should have a purpose text line 2' do
        Factory.create_iban_payment(:identification_purpose => 'U', :purpose_line_2 => 'LINE 2').segment5[38,35].should == 'LINE 2'.ljust(35)
      end

      it 'should have a purpose text line 3' do
        Factory.create_iban_payment(:identification_purpose => 'U', :purpose_line_3 => 'LINE 3').segment5[73,35].should == 'LINE 3'.ljust(35)
      end
    end
    
    it "should have a rule of charge" do
      Factory.create_iban_payment(:rule_of_charge => '2').segment5[108,1].should == '2'
    end
    
    it 'should have a reserve field' do
      Factory.create_iban_payment.segment5[109,19].should == ' '.ljust(19) 
    end
    
    it 'should have a total length of 128 characters' do
      Factory.create_iban_payment.segment5.size.should == 128
    end
  end

  describe 'comparison' do
    it "should sort by issuer identification" do
      @record1 = Factory.create_iban_payment(:issuer_identification => "AAAAA")
      @record2 = Factory.create_iban_payment(:issuer_identification => "BBBBB")
    
      (@record1 < @record2).should be_true
    end
  
    it "should sort by issuers clearing number when issuer identifications are equal" do
      @record1 = Factory.create_iban_payment(:issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '253')
      @record2 = Factory.create_iban_payment(:issuer_identification => "AAAAA", :ordering_party_bank_clearing_number => '254')
    
      (@record1 < @record2).should be_true
    end
  end
end