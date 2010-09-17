module Localize
  class XMLadapter
    require 'xmlsimple'

    def self.get_trans
      tr = {}
      Dir.glob(File.join(Localize::location, "#{Localize::locale.to_s}.xml")).each do |file|
        f = (RUBY_VERSION < '1.9') ? ::File.open(file) : ::File.open(file, 'r:utf-8')
        tr.merge! ::XmlSimple.xml_in( f, 'KeyAttr'    => { 'item' => 'name' },
                                         'ForceArray' => [ 'item' ],
                                         'ContentKey' => '-content')
      end
      tr
    end
  end
end