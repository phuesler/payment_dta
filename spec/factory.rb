# coding: utf-8
require 'payment_dta/payments/esr_payment'
require 'payment_dta/payments/total_record'
class Factory
  def self.create_payment(type, attributes = {})
    send("create_#{type.to_s}_payment",attributes)
  end
  def self.create_esr_payment(attributes = {})
    default_attributes = {
      :requested_processing_date => Date.today.strftime('%y%m%d'),
      :payers_clearing_number => '254',
      :account_to_be_debited => '10235678',
      :payment_amount => '3949.75',
      :ordering_party_bank_clearing_number => '253'
    }.merge(attributes)
    ESRPayment.new(build_attributes(default_attributes))
  end
    
  def self.create_domestic_chf_payment(attributes = {})
    default_attributes = {
      :requested_processing_date => Date.today.strftime('%y%m%d'),
    }.merge(attributes)
    DomesticCHFPayment.new(build_attributes(default_attributes))
  end
  
  def self.create_financial_institution_payment(attributes = {})
    default_attributes = {
      :identification_bank_address => 'A',
    }.merge(attributes)
    FinancialInstitutionPayment.new(build_attributes(default_attributes))
  end

  def self.create_special_financial_institution_payment(attributes = {})
    default_attributes = {
      :identification_bank_address => 'A',
      :identification_purpose => 'I',
      :purpose_structured_reference_number => 'i3or6cev1wog5ez5og8j',
      :rule_of_charge => '2'
    }.merge(attributes)
    SpecialFinancialInstitutionPayment.new(build_attributes(default_attributes))
  end
    
  def self.create_bank_cheque_payment(attributes = {})
    default_attributes = {
      
    }.merge(attributes)
    BankChequePayment.new(build_attributes(default_attributes))
  end
  
  def self.create_iban_payment(attributes = {})
    default_attributes = {
      :identification_bank_address => 'A',
      :identification_purpose => 'I',
      :purpose_structured_reference_number => 'i3or6cev1wog5ez5og8j',
      :rule_of_charge => '2'
    }.merge(attributes)
    IBANPayment.new(build_attributes(default_attributes))
  end
  
  def self.create_total_payment(attributes = {})
    default_attributes = {
      :data_file_sender_identification => 'PAYDT',
      :total_amount => 233.451,
    }.merge(attributes)
    TotalRecord.new(default_attributes)
  end
  class << self
    alias :create_total_record :create_total_payment
  end
  
  private
  
  def self.build_attributes(attributes = {})
    {
      :data_file_sender_identification => 'PAYDT',
      :payment_amount_currency         => 'CHF',
      :issuer_identification           => 'ABC01',
      :transaction_number              => rand(100000000000).to_s,
      :output_sequence_number          => 0,
      :payment_amount_value_date => Date.today.strftime('%y%m%d')
    }.merge(attributes)
  end
end
