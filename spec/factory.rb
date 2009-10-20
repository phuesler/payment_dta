require 'payments/esr_payment'
require 'payments/total_record'
class Factory
  def self.create_payment(type, attributes = {})
    send("create_#{type.to_s}_payment",attributes)
  end
  def self.create_esr_payment(attributes = {})
    default_attributes = {
      :requested_processing_date => Date.today.strftime('%y%m%d'),
      :data_file_sender_identification => 'ÄÜ2',
      :output_sequence_number => 1,
      :payers_clearing_number => '254',
      :account_to_be_debited => '10235678',
      :payment_amount_currency => 'CHF',
      :payment_amount => '3949.75',
      :issuer_identification => 'ABC01',
      :transaction_number => rand(100000000000).to_s,
      :ordering_party_bank_clearing_number => '253'
    }.merge(attributes)
    ESRPayment.new(default_attributes)
  end
  
  def self.create_total_payment(attributes = {})
    default_attributes = {
      :data_file_sender_identification => 'ÄÜ2',
      :total_amount => 233.451,
    }.merge(attributes)
    TotalRecord.new(default_attributes)
  end
  
  def self.create_domestic_chf_payment(attributes = {})
    default_attributes = {
      :requested_processing_date => Date.today.strftime('%y%m%d'),
      :data_file_sender_identification => 'ÄÜ2',
      :payment_amount_currency => 'CHF',
      :issuer_identification => 'ABC01',
      :transaction_number => rand(100000000000).to_s,
      :output_sequence_number => 1,
    }.merge(attributes)
    DomesticCHFPayment.new(default_attributes)
  end
  
  def self.create_financial_institution_payment(attributes = {})
    default_attributes = {
      :requested_processing_date => Date.today.strftime('%y%m%d'),
      :data_file_sender_identification => 'ÄÜ2',
      :payment_amount_currency => 'CHF',
      :issuer_identification => 'ABC01',
      :transaction_number => rand(100000000000).to_s,
      :output_sequence_number => 1,
      :identification_bank_address => 'A',
    }.merge(attributes)
    FinancialInstitutionPayment.new(default_attributes)
  end
  class << self
    alias :create_total_record :create_total_payment
  end
end