require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "PaymentDtaCh" do
  it "it should set a blank execution date" do
    DtaFile.new.data.should == "000000"
  end  
end
