require 'records/esr_record'
class Factory
  def self.create_esr_record(attributes = {})
    default_attributes = {
      :file_identification => 'ABC12',
      :sequence_number => 1,
      :payers_clearing_number => '254',
      :debit_account_number => '10235678',
      :debit_amount_currency => 'CHF',
      :debit_amount => '3949.75',
      :issuer_identification => 'ABC01',
      :issuer_transaction_number => rand(1000000000).to_s.rjust(11,"0"),
      :issuer_clearing_number => '253'
    }.merge(attributes)
    ESRRecord.new(default_attributes)
  end
end