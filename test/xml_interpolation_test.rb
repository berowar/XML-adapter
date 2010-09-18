require File.join(File.dirname(__FILE__), '../lib/localize')

describe Localize do
  before do
    Localize.store = :xml
    Localize.location = 'stores'
    @t = Localize.translate
  end

  it "Interpolate one param" do
    @t.interp_test.one('one').should == 'It interpolate one param'
  end

  it "Interpolate many params" do
    @t.interp_test.many('one', 'two', 'three').should == 'It interpolate one, two, three and more params'
  end

  it "Interpolate many params with shuffle" do
    @t.interp_test.shuffle('one', 'two', 'three').should == 'It shuffle two, three, one'
  end

  it "Repeat params" do
    @t.interp_test.repeat('one', 'two').should == 'It repeat one, two, one'
  end

  it "Ignore more params" do
    @t.interp_test.ignore('one', 'two', 'three', 'four').should == 'It print one, two, and not print other'
  end

  it "Ignore more interpolations" do
    @t.interp_test.ignore_more('one', 'two').should == 'It print one, two, but not ${3}'
  end
end