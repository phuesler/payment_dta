require 'payment'
class ESRPayment < Payment

 protected
 
 def build_segment1
  super + reference_number + debit_account_number + debit_amount + reserve_field(14)
 end
 
 def build_segment2
   super + issuer_address + reserve_field(46)
 end
 
 def build_segment3
   super + recipient_esr_number + recipient_address + esr_reference_number + recipient_esr_number_check + reserve_field(5)
 end

 private
 
 def reference_number
  @data[:reference_number]
 end
 
 def debit_account_number
  @data[:debit_account_number].ljust(24)
 end
 
 def debit_amount
   debit_amount_valuta + debit_amount_currency + debit_amount_value
 end
 
 def debit_amount_valuta
  " ".ljust(6)
 end
 
 def debit_amount_currency
  @data[:debit_amount_currency]
 end
 
 def debit_amount_value
  @data[:debit_amount].ljust(12)
 end
 
 def reserve_field(length = 14)
  " ".ljust(length)
 end
 
 def issuer_address
  issuer_address_line1 + issuer_address_line2 + issuer_address_line3 + issuer_address_line4
 end
 
 def issuer_address_line1
   @data[:issuer_address_line1].to_s.ljust(20)
 end

 def issuer_address_line2
   @data[:issuer_address_line2].to_s.ljust(20)
 end

 def issuer_address_line3
   @data[:issuer_address_line3].to_s.ljust(20)
 end

 def issuer_address_line4
   @data[:issuer_address_line4].to_s.ljust(20)
 end
 
 def recipient_esr_number
  "/C/#{@data[:recipient_esr_number].to_s.rjust(9,'0')}"
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
 
 def esr_reference_number
  if @data[:recipient_esr_number].to_s.size == 5
    @data[:esr_reference_number].to_s.ljust(27)
  else
    @data[:esr_reference_number].to_s.rjust(27,'0')
  end
 end
 
 def recipient_esr_number_check
  @data[:recipient_esr_number_check].to_s.ljust(2)
 end
end