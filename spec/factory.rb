require 'records/esr_record'
require 'records/total_record'
class Factory
  def self.create_record(type, attributes = {})
    send("create_#{type.to_s}_record",attributes)
  end
  def self.create_esr_record(attributes = {})
    default_attributes = {
      :requested_processing_date => Date.today.strftime('%y%m%d'),
      :data_file_sender_identification => 'ABC12',
      :output_sequence_number => 1,
      :payers_clearing_number => '254',
      :debit_account_number => '10235678',
      :debit_amount_currency => 'CHF',
      :debit_amount => '3949.75',
      :issuer_identification => 'ABC01',
      :issuer_transaction_number => rand(100000000000).to_s,
      :ordering_party_bank_clearing_number => '253'
    }.merge(attributes)
    ESRRecord.new(default_attributes)
  end
  
  def self.create_total_record(attributes = {})
    default_attributes = {
      :data_file_sender_identification => 'ABC12',
      :total_amount => 233.451,
    }.merge(attributes)
    TotalRecord.new(default_attributes)
  end
end