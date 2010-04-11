require File.join(File.dirname(__FILE__), '../lib/localize')

describe Localize do
  before do
    Localize.location = 'stores'
  end

  it "Format phone numbers" do
    Localize.l(380446666666).should == '+380 (44) 666-66-66'
  end

  it "Format and truncate phone numbers" do
    Localize.l(380446666666, :short).should == '666-66-66'
  end
  
  it "Localize dates" do
    Localize.l(Time.utc(2000, "jan")).should == 'Sat Jan 01 00:00:00 UTC 2000'
  end

  it "Format dates" do
    Localize.l(Time.utc(2000, "jan"), :short).should == 'Sat 01-January-00'
  end

  it "Format numbers" do
    Localize.l(1000.02).should == '1,000.02'
  end
end