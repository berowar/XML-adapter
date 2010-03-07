# encoding: utf-8
$KCODE = 'u' if RUBY_VERSION < '1.9'

module Localize
  
  autoload :YAMLadapter, File.join(File.dirname(__FILE__), 'localize/adapters/yaml')

  @@default_locale = :en
  @@locale = @@default_locale
  @@store = :yaml
  @@location = ''

  class << self
    def load(locale=nil, location=nil)
      @@locale = locale if locale
      @@location = location if location
      @@trans ||= tr(@@store)
      @@trans[:text]
    end
    
    def reset!
      @@trans = nil
    end
    
    def tr(adapter)
      ret = case @@store
        when :yaml
          YAMLadapter.get_trans
        else
          raise "Adapter not avalaible: #{adapter}"
      end
      {
        :text => Translation.new(ret['text']),
        :formats => ret['formats']
      }
    end
    
    def store=(str)
      reset!
      @@store = str
    end
    
    def store
      @@store
    end
    
    def locale=(loc)
      reset!
      @@locale = loc
    end
    
    def locale
      @@locale
    end
    
    def default_locale=(loc)
      reset!
      @@locale = loc
    end
    
    def default_locale
      @@locale
    end
    
    def location=(locat)
      reset!
      @@location = locat
    end
    
    def location
      @@location
    end
  end
  
  class Translation
    def initialize(hash)
      hash.each_pair do |key, value|
        value = Translation.new(value) if value.is_a?(Hash)
        instance_variable_set("@#{key}", value)
        self.class.class_eval do
          define_method("#{key}") { instance_variable_get("@#{key}") }
        end
      end
    end

    def method_missing(name, *params)
      MissString.new('Translation missing: '+name.to_s)
    end
  end
  
  class MissString < String
    def method_missing(name, *params)
      self << '.' + name.to_s
    end
  end
end