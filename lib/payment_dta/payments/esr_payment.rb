require 'payment_dta/payments/base'
require 'payment_dta/payment_sorting'

class ESRPayment < DTA::Payments::Base
 include DTA::Payment::Sortable
 
 def record
   @record ||= segment1 + segment2 + segment3
 end
 
 def transaction_type
   '826'
 end
 
 def payment_type
   '0'
 end
 
 def beneficiarys_esr_party_number
  "/C/#{@data[:beneficiarys_esr_party_number].to_s.rjust(9,'0')}"
 end
  
 def reason_for_payment_esr_reference_number
  if @data[:beneficiarys_esr_party_number].to_s.size == 5
    @data[:reason_for_payment_esr_reference_number].to_s.ljust(27)
  else
    @data[:reason_for_payment_esr_reference_number].to_s.rjust(27,'0')
  end
 end
 
 def beneficiarys_esr_party_number_check
  @data[:beneficiarys_esr_party_number_check].to_s.ljust(2)
 end
 
 protected
 
 def build_segment1
  super + reference_number + account_to_be_debited + payment_amount + reserve_field(14)
 end
 
 def build_segment2
   super + ordering_partys_address(20) + reserve_field(46)
 end
 
 def build_segment3
   super + beneficiarys_esr_party_number + beneficiary_address(20) + reason_for_payment_esr_reference_number + beneficiarys_esr_party_number_check + reserve_field(5)
 end 
end