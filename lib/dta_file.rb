require 'set'
class DTAFile
  attr_reader :records
  
  def initialize(path, issuer_transaction_number = rand(100000000000).to_s)
    @issuer_transaction_number = issuer_transaction_number.to_s
    @path = path
    @records = SortedSet.new
  end
  
  def write_file
    File.open(@path,"w") do |file|
      @records.each{|record| file.puts record.record}
    end
  end
  
  def <<(record)
    record.issuer_transaction_number = @issuer_transaction_number
    @records << record
    recalculate_sequence_numbers
  end

  def self.create(path)
    dta_file = self.new(path)
    yield dta_file
    dta_file.write_file
    dta_file
  end
  
  private
  
  def recalculate_sequence_numbers
    start = 1
    @records.each do |record|
      record.sequence_number = start
      start += 1
    end
  end

end