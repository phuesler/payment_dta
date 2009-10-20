module DTA
  module Payment
    module Sortable
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
    end
  end
end
