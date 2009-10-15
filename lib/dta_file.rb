class DTAFile
  attr_reader :records
  class RecordCollection < Array
    def <<(record)
      super
      sort!
    end
  end
  def initialize(path)
    @path = path
    @records = RecordCollection.new
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