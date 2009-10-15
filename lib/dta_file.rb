class DTAFile
  attr_accessor :records
  
  def initialize
    @records = []
  end
  def self.create(path)
    dta_file = self.new
    yield dta_file
    File.open(path,"w") do |file|
      dta_file.records.each{|record| file.puts record.record}
    end
    dta_file
  end
  
  def << (record)
    @records << record
  end
end