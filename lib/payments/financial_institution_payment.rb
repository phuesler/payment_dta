require 'payments/base'
require 'payment_sorting'

class FinancialInstitutionPayment < DTA::Payments::Base
  include DTA::Payment::Sortable
  
  def transaction_type
    '830'
  end
  
  def payment_type
    '0'
  end
  
  def payment_amount_value
   @data[:payment_amount].to_s.ljust(15)
  end
  
  def payment_amount_value_date
   @data[:payment_amount_value_date].to_s.ljust(6)
  end
  
  def convertion_rate
    @data[:convertion_rate].to_s.ljust(12)
  end
  
  def identification_bank_address
    @data[:identification_bank_address].to_s
  end
  
  def beneficiary_bank_account_number
    "/C/#{@data[:beneficiary_bank_account_number].to_s}".ljust(24)
  end
  
  def beneficiary_institution_bank_account_number
    "/C/#{@data[:beneficiary_institution_bank_account_number]}".ljust(24)
  end
  
  def beneficiary_institution_address(line_size=24)
    if identification_bank_address == 'A'
      @data[:beneficiarys_institution_swift_address_].to_s.ljust(24) + ''.ljust(72)
    else
      beneficiary_institution_address_line1 + beneficiary_institution_address_line2 + beneficiary_institution_address_line3 + beneficiary_institution_address_line4
    end
  end
   
  def beneficiary_institution_address_line1
   @data[:beneficiary_institution_address_line1].to_s.ljust(24)
  end

  def beneficiary_institution_address_line2
   @data[:beneficiary_institution_address_line2].to_s.ljust(24)
  end

  def beneficiary_institution_address_line3
   @data[:beneficiary_institution_address_line3].to_s.ljust(24)
  end

  def beneficiary_institution_address_line4
   @data[:beneficiary_institution_address_line4].to_s.ljust(24)
  end
  
  def bank_payment_instructions
    @data[:bank_payment_instructions].to_s.ljust(120)
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