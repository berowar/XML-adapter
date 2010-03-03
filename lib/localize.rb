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
      Translation.new(tr(@@store))
    end
    
    def tr(adapter)
      ret = case adapter
        when :yaml
          YAMLadapter.get_trans
        else
          raise "Adapter not avalaible: #{adapter}"
      end
      return ret
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
      m_missed(name)
    end

    def m_missed(name)
      p "Translation missing: #{name}"
      self
    end
  end
end