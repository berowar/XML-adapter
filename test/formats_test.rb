require File.join(File.dirname(__FILE__), '../lib/localize')

describe Localize do
  before do
    Localize.location = 'stores'
  end

  it "Format phone numbers" do
    Localize.l(6666666).should == '666-66-66'
  end
  
  it "Localize dates" do
    Localize.l(Time.utc(2000, "jan")).should == 'Sat Djan 01 00:00:00 UTC 2000'
  end
end