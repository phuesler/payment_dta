require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
%w(esr_payment domestic_chf_payment total_record).each do |payment_type|
  require "payments/#{payment_type}"
end

shared_examples_for "all headers" do
  it 'should have a total length of 51 characters' do
    Factory.create_payment(@type).header.size.should == 51
  end
    
  it 'should fill out a blank output sequence number' do
    Factory.create_payment(@type).header[18,5].should == '00000'
  end
  
  it 'should set the creation date' do
    Factory.create_payment(@type).header[23,6].should == Date.today.strftime('%y%m%d')
  end
  
  it 'should set the data file sender identification' do
    Factory.create_payment(@type,:data_file_sender_identification => 'ABC12').header[36,5].should == 'ABC12'
  end
  
  it 'should should set the entry sequence number' do
   Factory.create_payment(@type,:entry_sequence_number => 1).header[41,5].should == '00001'
  end
  
  it 'should set the processing flag to 0' do
   Factory.create_payment(@type).header[50,1].should == '0' 
  end
end

describe ESRPayment, 'header' do
  before(:each) do
    @type = :esr
  end
  
  it_should_behave_like 'all headers'
  
  it 'should set a the correct processing date' do
    Factory.create_esr_payment(:requested_processing_date => '051021').header[0,6].should == '051021'
  end
    
  it 'should fill the beneficiarys bank clearing number with blanks' do
    Factory.create_esr_payment.header[6,12].should == ''.ljust(12,' ')
  end

  it 'should set the ordering party bank clearing number' do
    Factory.create_esr_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '2540000'
  end

  it 'should should set the transaction type to 826' do
   Factory.create_esr_payment.header[46,3].should == '826' 
  end

  it 'should set the payment type to 0' do
   Factory.create_esr_payment.header[49,1].should == '0' 
  end
end

describe DomesticCHFPayment, 'header' do
  before(:each) do
    @type = :domestic_chf
  end
  it_should_behave_like 'all headers'
  
  it 'should set a the correct processing date' do
    Factory.create_domestic_chf_payment(:requested_processing_date => '051021').header[0,6].should == '051021'
  end
  
  it 'should fill the beneficiarys bank clearing number with blanks' do
    Factory.create_domestic_chf_payment(:beneficiary_bank_clearing_number => "99999").header[6,12].should == '99999'.ljust(12,' ')
  end
  
  it 'should set the ordering party bank clearing number' do
    Factory.create_domestic_chf_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '2540000'
  end
  
  it 'should should set the transaction type to 827' do
   Factory.create_domestic_chf_payment.header[46,3].should == '827' 
  end

  it 'should set the payment type to 0' do
   Factory.create_domestic_chf_payment.header[49,1].should == '0' 
  end
end

describe TotalRecord, 'header' do
  before(:each) do
    @type = :total
  end
  
  it_should_behave_like 'all headers'
  
  it 'should fill the ordering party bank clearing number with blanks' do
    Factory.create_total_payment.header[29,7].should == '       '
  end
  
  it 'should should set the transaction type to 890' do
   Factory.create_total_payment.header[46,3].should == '890' 
  end
  
  it 'should set the payment type to 0' do
   Factory.create_total_payment.header[49,1].should == '0' 
  end
  
  it 'should set a the correct processing date' do
    Factory.create_total_payment.header[0,6].should == '000000'
  end
end