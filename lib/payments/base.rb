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
      
      def segment4
        @segment4 ||= build_segment4
      end

      def segment5
        @segment5 ||= build_segment5
      end
      
      def record
        @record ||= segment1 + segment2 + segment3 + segment4 + segment5
      end

      def header
        @header ||= build_header
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

      def processing_flag
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
         payment_amount_value_date + payment_amount_currency + payment_amount_value
      end

      def payment_amount_value_date
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

      def ordering_partys_address(line_size=24)
      ordering_partys_address_line1(line_size) + ordering_partys_address_line2(line_size) + ordering_partys_address_line3(line_size) + ordering_partys_address_line4(line_size)
      end

      def ordering_partys_address_line1(line_size = 24)
       @data[:ordering_partys_address_line1].to_s.ljust(line_size)
      end

      def ordering_partys_address_line2(line_size = 24)
       @data[:ordering_partys_address_line2].to_s.ljust(line_size)
      end

      def ordering_partys_address_line3(line_size = 24)
       @data[:ordering_partys_address_line3].to_s.ljust(line_size)
      end

      def ordering_partys_address_line4(line_size = 24)
       @data[:ordering_partys_address_line4].to_s.ljust(line_size)
      end

      def beneficiary_address(line_size=24)
      beneficiary_address_line1(line_size) + beneficiary_address_line2(line_size) + beneficiary_address_line3(line_size) + beneficiary_address_line4(line_size)
      end

      def beneficiary_address_line1(line_size=24)
       @data[:beneficiary_address_line1].to_s.ljust(line_size)
      end

      def beneficiary_address_line2(line_size=24)
       @data[:beneficiary_address_line2].to_s.ljust(line_size)
      end

      def beneficiary_address_line3(line_size=24)
       @data[:beneficiary_address_line3].to_s.ljust(line_size)
      end

      def beneficiary_address_line4(line_size=24)
       @data[:beneficiary_address_line4].to_s.ljust(line_size)
      end

      def reason_for_payment_message(line_size=24)
       reason_for_payment_message_line1(line_size) + reason_for_payment_message_line2(line_size) + reason_for_payment_message_line3(line_size) + reason_for_payment_message_line4(line_size)
      end

      def reason_for_payment_message_line1(line_size=24)
       @data[:reason_for_payment_message_line1].to_s.ljust(line_size)
      end

      def reason_for_payment_message_line2(line_size=24)
       @data[:reason_for_payment_message_line2].to_s.ljust(line_size)
      end

      def reason_for_payment_message_line3(line_size=24)
       @data[:reason_for_payment_message_line3].to_s.ljust(line_size)
      end

      def reason_for_payment_message_line4(line_size=24)
       @data[:reason_for_payment_message_line4].to_s.ljust(line_size)
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
      
      def build_segment4
        '04'
      end

      def build_segment5
        '05'
      end
      
      def build_header
        requested_processing_date + beneficiary_bank_clearing_number + output_sequence_number + creation_date + ordering_party_bank_clearing_number + data_file_sender_identification + entry_sequence_number + transaction_type + payment_type + processing_flag    
      end
      
      def reserve_field(length = 14)
       ''.ljust(length)
      end
    end 
  end
end