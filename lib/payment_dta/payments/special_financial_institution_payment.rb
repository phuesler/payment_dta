require 'payment_dta/payments/base'
require 'payment_dta/payment_sorting'

class SpecialFinancialInstitutionPayment < DTA::Payments::Base
  include DTA::Payment::Sortable
    
  def record
    @record ||= segment1 + segment2 + segment3 + segment4 + segment5
  end
  
  def transaction_type
    '837'
  end
  
  def payment_type
    '1'
  end
  
  def requested_processing_date
    '000000'
  end
  
  def account_to_be_debited
    @data[:account_to_be_debited].to_s.ljust(34)
  end
  
  def payment_amount_value
    super(15)
  end
  
  def payment_amount_value_date
   @data[:payment_amount_value_date].to_s.ljust(6)
  end
  
  def convertion_rate
    @data[:convertion_rate].to_s.ljust(12)
  end
  
  protected
  
  def build_segment1
    super + reference_number + account_to_be_debited + payment_amount + reserve_field(1)
  end
  
  def build_segment2
    super + convertion_rate + ordering_partys_address(24) + reserve_field(18)
  end

  def build_segment3
    super + identification_bank_address + beneficiary_institution_bank_account_number + beneficiary_institution_address + reserve_field(5)
  end
  
  def build_segment4
    super + beneficiary_bank_account_number + beneficiary_address(24) + reserve_field(6)
  end
  
  def build_segment5
    super + beneficiary_iban_number + reserve_field(92)
  end
  
  def build_segment6
    super + identification_purpose + purpose + rule_of_charge + reserve_field(19)
  end
end