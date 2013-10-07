require 'set'
require 'payment_dta/payments/total_record'
class DTAFile
  attr_reader :records
  
  def initialize(path, transaction_number = rand(100000000000).to_s)
    @transaction_number = transaction_number.to_s
    @path = path
    @records = SortedSet.new
  end
  
  def write_file
    File.open(@path,"w") do |file|
      @records.each{|record| file.puts record.to_dta}
      file.puts build_total_record.to_dta
    end
  end
  
  def total
    @records.inject(0) do |sum, record|
      sum + record.amount.to_f
    end
  end
  
  def <<(record)
    record.transaction_number = @transaction_number
    @records << record
    recalculate_entry_sequence_numbers
  end

  def dta_string
    (@records.map(&:to_dta) << build_total_record.to_dta) * "\n" << "\n"
  end

  def self.create(path)
    dta_file = self.new(path)
    yield dta_file
    dta_file.write_file
    dta_file
  end
  
  private

  def recalculate_entry_sequence_numbers
    start = 1
    @records.each do |record|
      record.entry_sequence_number = start
      start += 1
    end
  end
  
  def build_total_record
    TotalRecord.new(
      :total_amount => total,
      :data_file_sender_identification => @records.first.data_file_sender_identification
    )
  end

end
