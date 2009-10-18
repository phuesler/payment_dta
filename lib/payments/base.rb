require 'date'
require 'character_conversion'

module DTA
  module Payments
    class Base
      include DTA::CharacterConversion
      
      def initialize(data = {})
        @data = data
      end
      
      def to_dta
        dta_string(record)
      end

      def segment1
        @segment1 ||= build_segment1 
      end

      def segment2
        @segment2 ||= build_segment2
      end

      def segment3
        @segment3 ||= build_segment3
      end

      def header
        @header ||= build_header
      end

      def record
        @record ||= segment1 + segment2 + segment3
      end
      
      def requested_processing_date
        @data[:requested_processing_date]
      end

      def beneficiary_bank_clearing_number
        @data[:beneficiary_bank_clearing_number].to_s.ljust(12,' ')
      end

      def output_sequence_number
        @output_sequence_number.to_s.rjust(5,'0')
      end
      
      def output_sequence_number=(output_sequence_number)
        @output_sequence_number = output_sequence_number
      end

      def creation_date
        Date.today.strftime('%y%m%d')
      end

      def ordering_party_bank_clearing_number
        @data[:ordering_party_bank_clearing_number].to_s.ljust(7,'0')
      end

      def data_file_sender_identification
        if @data[:data_file_sender_identification].nil?
          raise 'No file identification'
        else
          @data[:data_file_sender_identification]
        end
      end

      def entry_sequence_number
        @data[:entry_sequence_number].to_s.rjust(5,'0')
      end

      def payment_type
        '1'
      end

      def transaction_flag
        '0'
      end

      protected

      def build_segment1
        '01'+ header
      end

      def build_segment2
        '02'
      end

      def build_segment3
        '03'
      end

      def build_header
        requested_processing_date + beneficiary_bank_clearing_number + output_sequence_number + creation_date + ordering_party_bank_clearing_number + data_file_sender_identification + entry_sequence_number + transaction_type + payment_type + transaction_flag    
      end
      
      def reserve_field(length = 14)
       ''.ljust(length)
      end
    end 
  end
end