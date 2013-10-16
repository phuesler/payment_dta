require 'payment_dta/payments/base'
require 'payment_dta/payment_sorting'

class FinancialInstitutionPayment < DTA::Payments::Base
  include DTA::Payment::Sortable
  
  def transaction_type
    '830'
  end
  
  def payment_type
    '0'
  end
  
  def requested_processing_date
    '000000'
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
   super + reference_number + account_to_be_debited + payment_amount + reserve_field(11)
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
    super + reason_for_payment_message(30) + reserve_field(6)
  end
  
  def build_segment6
    super + bank_payment_instructions + reserve_field(6)
  end
end