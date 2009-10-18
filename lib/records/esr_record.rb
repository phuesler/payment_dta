require 'records/base'
class ESRRecord < DTA::Records::Base
 include Comparable
 
 def <=>(other)
   if  requested_processing_date == other.requested_processing_date
     if issuer_identification == other.issuer_identification
       return ordering_party_bank_clearing_number <=> other.ordering_party_bank_clearing_number
     else
       return issuer_identification <=> other.issuer_identification
     end
   else
     return requested_processing_date <=> other.requested_processing_date
   end
 end
 
 def transaction_type
   '826'
 end
 
 def payment_type
   '0'
 end
  
 def issuer_identification
  @data[:issuer_identification].to_s
 end
 
 def transaction_number
  (@transaction_number || @data[:transaction_number]).to_s.ljust(11,'0')
 end
 
 def transaction_number=(transaction_number)
  @transaction_number = transaction_number
 end
 
 def reference_number
  issuer_identification + transaction_number
 end
 
 def account_to_be_debited
  @data[:account_to_be_debited].to_s.ljust(24)
 end
 
 def payment_amount
   payment_amount_valuta + payment_amount_currency + payment_amount_value
 end
 
 def payment_amount_valuta
  ''.ljust(6)
 end
 
 def payment_amount_currency
  @data[:payment_amount_currency].to_s
 end
 
 def amount
  @data[:payment_amount]
 end
 
 def payment_amount_value
  @data[:payment_amount].to_s.ljust(12)
 end
   
 def ordering_partys_address
  ordering_partys_address_line1 + ordering_partys_address_line2 + ordering_partys_address_line3 + ordering_partys_address_line4
 end
 
 def ordering_partys_address_line1
   @data[:ordering_partys_address_line1].to_s.ljust(20)
 end

 def ordering_partys_address_line2
   @data[:ordering_partys_address_line2].to_s.ljust(20)
 end

 def ordering_partys_address_line3
   @data[:ordering_partys_address_line3].to_s.ljust(20)
 end

 def ordering_partys_address_line4
   @data[:ordering_partys_address_line4].to_s.ljust(20)
 end
 
 def beneficiarys_esr_party_number
  "/C/#{@data[:beneficiarys_esr_party_number].to_s.rjust(9,'0')}"
 end
 
 def recipient_address
  recipient_address_line1 + recipient_address_line2 + recipient_address_line3 + recipient_address_line4
 end
 
 def recipient_address_line1
   @data[:recipient_address_line1].to_s.ljust(20)
 end

 def recipient_address_line2
   @data[:recipient_address_line2].to_s.ljust(20)
 end

 def recipient_address_line3
   @data[:recipient_address_line3].to_s.ljust(20)
 end

 def recipient_address_line4
   @data[:recipient_address_line4].to_s.ljust(20)
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
   super + ordering_partys_address + reserve_field(46)
 end
 
 def build_segment3
   super + beneficiarys_esr_party_number + recipient_address + reason_for_payment_esr_reference_number + beneficiarys_esr_party_number_check + reserve_field(5)
 end 
end