# encoding: utf-8
module Localize
  class YAMLadapter
    require 'yaml'
    
    def self.get_trans
      tr = {}
      Dir.glob(File.join(Localize::location, "#{Localize::locale.to_s}.yml")).each do |file|
        f = (RUBY_VERSION < '1.9') ? ::File.open(file) : ::File.open(file, 'r:utf-8')
        tr.merge! ::YAML.load(f)['text']
      end
      tr
    end
  end
end