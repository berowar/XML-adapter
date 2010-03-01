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
      #Translate.new
      tr(@@store)
    end
    
    def tr(adapter)
      ret = case adapter
        when :yaml
          to_obj YAMLadapter.get_trans
        else
          raise "Adapter not avalaible: #{adapter}"
      end
      return ret
    end
    
    def to_obj(hash)
      obj = Translation.new
      hash.each_pair do |key, value|
        if value.is_a?(Hash)
          obj.set(key, to_obj(value))
        else
          obj.set(key, value)
        end
      end
      obj
    end
    
    def store=(str)
      @@store = str
    end
    
    def store
      @@store
    end
    
    def locale=(loc)
      @@locale = loc
    end
    
    def locale
      @@locale
    end
    
    def default_locale=(loc)
      @@locale = loc
    end
    
    def default_locale
      @@locale
    end
    
    def location=(locat)
      @@location = locat
    end
    
    def location
      @@location
    end
  end
  
  class Translation
    def set(key, value)
      instance_variable_set("@#{key}", value)
      
      self.class.class_eval do
        define_method("#{key}") { instance_variable_get("@#{key}") }
      end
    end
    
    def method_missing(name)
      "Translation missing: #{name}"
    end
  end
end