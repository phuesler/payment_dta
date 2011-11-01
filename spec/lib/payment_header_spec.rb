require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
%w(esr_payment domestic_chf_payment financial_institution_payment bank_cheque_payment iban_payment special_financial_institution_payment total_record).each do |payment_type|
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
    Factory.create_esr_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '254    '
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
    Factory.create_domestic_chf_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '254    '
  end

  it 'should should set the transaction type to 827' do
   Factory.create_domestic_chf_payment.header[46,3].should == '827'
  end

  it 'should set the payment type to 0' do
   Factory.create_domestic_chf_payment.header[49,1].should == '0'
  end
end

describe FinancialInstitutionPayment, 'header' do
  before(:each) do
    @type = :financial_institution
  end

  it_should_behave_like 'all headers'

  it 'should fill the requested processing date with zeros' do
    Factory.create_financial_institution_payment.header[0,6].should == '000000'
  end

  it 'should fill the beneficiarys bank clearing number with blanks' do
    Factory.create_financial_institution_payment.header[6,12].should == ''.ljust(12,' ')
  end

  it 'should set the ordering party bank clearing number' do
    Factory.create_financial_institution_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '254    '
  end

  it 'should should set the transaction type to 830' do
   Factory.create_financial_institution_payment.header[46,3].should == '830'
  end

  it 'should set the payment type to 0' do
   Factory.create_financial_institution_payment.header[49,1].should == '0'
  end
end

describe BankChequePayment, 'header' do
  before(:each) do
    @type = :bank_cheque
  end

  it_should_behave_like 'all headers'

  it 'should fill the requested processing date with zeros' do
    Factory.create_bank_cheque_payment.header[0,6].should == '000000'
  end

  it 'should fill the beneficiarys bank clearing number with blanks' do
    Factory.create_bank_cheque_payment.header[6,12].should == ''.ljust(12,' ')
  end

  it 'should set the ordering party bank clearing number' do
    Factory.create_bank_cheque_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '254    '
  end

  it 'should should set the transaction type to 832' do
   Factory.create_bank_cheque_payment.header[46,3].should == '832'
  end

  it 'should set the payment type to 0' do
   Factory.create_bank_cheque_payment.header[49,1].should == '0'
  end
end

describe IBANPayment, 'header' do
  before(:each) do
    @type = :iban
  end

  it_should_behave_like 'all headers'

  it 'should fill the requested processing date with zeros' do
    Factory.create_iban_payment.header[0,6].should == '000000'
  end

  it 'should fill the beneficiarys bank clearing number with blanks' do
    Factory.create_iban_payment.header[6,12].should == ''.ljust(12,' ')
  end

  it 'should set the ordering party bank clearing number' do
    Factory.create_iban_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '254    '
  end

  it 'should should set the transaction type to 836' do
   Factory.create_iban_payment.header[46,3].should == '836'
  end

  it 'should set the payment type to 1' do
   Factory.create_iban_payment.header[49,1].should == '1'
  end
end

describe SpecialFinancialInstitutionPayment, 'header' do
  before(:each) do
    @type = :special_financial_institution
  end

  it_should_behave_like 'all headers'

  it 'should fill the requested processing date with zeros' do
    Factory.create_special_financial_institution_payment.header[0,6].should == '000000'
  end

  it 'should fill the beneficiarys bank clearing number with blanks' do
    Factory.create_special_financial_institution_payment.header[6,12].should == ''.ljust(12,' ')
  end

  it 'should set the ordering party bank clearing number' do
    Factory.create_special_financial_institution_payment(:ordering_party_bank_clearing_number => '254').header[29,7].should == '254    '
  end

  it 'should should set the transaction type to 837' do
   Factory.create_special_financial_institution_payment.header[46,3].should == '837'
  end

  it 'should set the payment type to 1' do
   Factory.create_special_financial_institution_payment.header[49,1].should == '1'
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
