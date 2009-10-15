require 'set'
class DTAFile
  attr_reader :records
  
  def initialize(path)
    @path = path
    @records = SortedSet.new
  end
  
  def write_file
    File.open(@path,"w") do |file|
      @records.each{|record| file.puts record.record}
    end
  end
  
  def <<(record)
    @records << record
  end
  
  def self.create(path)
    dta_file = self.new(path)
    yield dta_file
    dta_file.write_file
    dta_file
  end

end