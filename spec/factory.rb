require 'records/esr_record'
class Factory
  def self.create_esr_record(attributes = {})
    default_attributes = {
      :file_identification => 'ABC12',
      :sequence_number => 1,
      :payers_clearing_number => '254',
      :reference_number => 'ABC0100123478901',
      :debit_account_number => '10235678',
      :debit_amount_currency => 'CHF',
      :debit_amount => '3949.75'
    }.merge(attributes)
    ESRRecord.new(default_attributes)
  end
end