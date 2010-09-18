require File.join(File.dirname(__FILE__), '../lib/localize')

describe Localize do
  it "Get translation from plain" do
    Localize.store      = :plain
    Localize.location   = {
      'text' => {
        'hello' => 'world'
      }
    }
    t = Localize.translate
    t.hello.should == 'world'
  end

  it "Get translation from yaml" do
    Localize.store = :yaml
    Localize.load(:en, 'stores')
    t = Localize.translate
    t.hello.should == 'world'
  end
  
  it "Get translation from xml" do
    Localize.store = :xml
    Localize.load(:en, 'stores')
    t = Localize.translate
    t.hello.should == 'world'
  end
  
  it "Accept nested translations" do
    t = Localize.translate
    t.foo.bar.should == 'baz'
  end

  it "Return right error" do
    t = Localize.translate
    t.fee.should == 'Translation missing: fee'
  end

  it "Return right error with nested translation" do
    t = Localize.translate
    t.fee.baz.should == 'Translation missing: fee.baz'
  end
end