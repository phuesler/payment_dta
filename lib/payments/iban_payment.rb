require 'payments/base'
require 'payment_sorting'

class IBANPayment < DTA::Payments::Base
  include DTA::Payment::Sortable
  
  def record
    @record ||= segment1 + segment2 + segment3 + segment4 + segment5
  end

  def transaction_type
    '836'
  end

  def payment_type
    '1'
  end
  
  def requested_processing_date
    '000000'
  end
  
  def payment_amount_value_date
   @data[:payment_amount_value_date].to_s.ljust(6)
  end
  
  def payment_amount_value
  @data[:payment_amount].to_s.ljust(15)
  end
  
  def convertion_rate
    @data[:convertion_rate].to_s.ljust(12)
  end
  
  def ordering_partys_address(line_size = 35)
    ordering_partys_address_line1(line_size) + ordering_partys_address_line2(line_size) + ordering_partys_address_line3(line_size)
  end
  
  def identification_bank_address
    @data[:identification_bank_address].to_s
  end
  
  def beneficiary_institution_address(line_size=24)
    if identification_bank_address == 'A'
      @data[:beneficiarys_institution_swift_address_].to_s.ljust(70)
    else
      @data[:beneficiary_institution_address_line1].to_s.ljust(35) + @data[:beneficiary_institution_address_line2].to_s.ljust(35)
    end
  end
  
  def beneficiary_iban_number
    @data[:beneficiary_iban_number].to_s.ljust(34)
  end
  
  def beneficiary_address(line_size=35)
    beneficiary_address_line1(line_size) + beneficiary_address_line2(line_size) + beneficiary_address_line3(line_size)
  end
  
  def identification_purpose
    @data[:identification_purpose].to_s[0,1]
  end
  
  def purpose
    if identification_purpose == 'I'
      @data[:purpose_structured_reference_number].to_s.ljust(105)
    else
      @data[:purpose_line_1].to_s.ljust(35) + @data[:purpose_line_2].to_s.ljust(35) + @data[:purpose_line_3].to_s.ljust(35)
    end
  end
  
  def rule_of_charge
    @data[:rule_of_charge].to_s[0,1]
  end
  
  protected
  
  def build_segment1
   super + reference_number + account_to_be_debited + payment_amount + reserve_field(11)
  end
  
  def build_segment2
     super + convertion_rate + ordering_partys_address + reserve_field(9)
  end

  def build_segment3
    super + identification_bank_address + beneficiary_institution_address + beneficiary_iban_number + reserve_field(21)
  end
  
  def build_segment4
    super + beneficiary_address + reserve_field(21)
  end
  
  def build_segment5
    super + identification_purpose + purpose + rule_of_charge + reserve_field(19)
  end
end