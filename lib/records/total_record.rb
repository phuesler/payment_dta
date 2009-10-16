require 'records/base'

class TotalRecord < DTA::Records::Base
  def segment1
    super + total_amount + reserve_field(59)
  end
  
  def record
    segment1
  end
  
  def total_amount
    @data[:total_amount].to_s.gsub(/\./,',').ljust(16)
  end
  
  def ordering_party_bank_clearing_number
    ''.ljust(7)
  end
  
  def transaction_type
    '890'
  end
  
  def payment_type
    '0'
  end
  
  def requested_processing_date
    '000000'
  end
end