require 'set'
class DTAFile
  class TransactionNumberGenerator
    CHARS = ['0'..'9'].collect{|x| x.to_a}.flatten
    def self.generate(length=11)
      number = ''
      length.times {number << CHARS[rand(CHARS.length)]}
      number
    end
  end
  
  attr_reader :records
  
  def initialize(path, issuer_transaction_number = TransactionNumberGenerator.generate)
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
  end
  
  def self.create(path)
    dta_file = self.new(path)
    yield dta_file
    dta_file.write_file
    dta_file
  end

end