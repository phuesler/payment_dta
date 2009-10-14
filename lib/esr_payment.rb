require 'payment'
class ESRPayment < Payment

 protected
 
 def build_segment1
  super + reference_number + debit_account_number + debit_amount + reserve_field
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
 
 def reserve_field
  " ".ljust(14)
 end

end