require 'date'
module DTA
  module Records
    class Base
      def initialize(data = {})
        @data = data
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
      
      def execution_date
        @data[:execution_date] || '000000'
      end

      def bank_clearing_number
        ''.ljust(12,' ')
      end

      def sequence_number
        '00000'
      end

      def creation_date
        Date.today.strftime('%y%m%d')
      end

      def issuer_clearing_number
        @data[:issuer_clearing_number].to_s.ljust(7,'0')
      end

      def file_identification
        if @data[:file_identification].nil?
          raise 'No file identification'
        else
          @data[:file_identification]
        end
      end

      def record_sequence_number
        @data[:record_sequence_number].to_s.rjust(5,'0')
      end

      def transaction_type
        '826'
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
        execution_date + bank_clearing_number + sequence_number + creation_date + issuer_clearing_number + file_identification + record_sequence_number + transaction_type + payment_type + transaction_flag    
      end
    end 
  end
end