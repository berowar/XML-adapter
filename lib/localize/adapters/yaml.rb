module Localize
  class YAMLadapter
    require 'yaml'
    
    def self.get_trans
      tr = {}
      Dir.glob(File.join(Localize::location, "#{Localize::locale.to_s}.yml")).each do |f|
        tr.merge! ::YAML.load_file(f)['text']
      end
      tr
    end
  end
end