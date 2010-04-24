# encoding: utf-8
$KCODE = 'u' if RUBY_VERSION < '1.9'

module Localize

  autoload :YAMLadapter, File.join(File.dirname(__FILE__), 'localize/adapters/yaml')
  autoload :Formats, File.join(File.dirname(__FILE__), 'localize/formats')

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

    def l(source, format = :full)
      @@trans ||= tr(@@store)

      if source.is_a?(Integer)
        Formats.number(source)
      elsif source.is_a?(Float)
        Formats.number(source)
      elsif source.is_a?(Time) or source.is_a?(Date)
        Formats.date(source, format)
      else
        raise "Format not recognize"
      end
    end

    def f(source, format = :full)
      @@trans ||= tr(@@store)

      phone = if source.is_a?(Integer)
        source
      elsif source.is_a?(String)
        source.gsub(/[\+., -]/, '').trim.to_i
      elsif source.is_a?(Float)
        source.to_s.gsub('.', '').to_i
      else
        raise "Format not recognize"
      end
      Formats.phone(phone, format)
    end

    def reset!
      @@trans = nil
    end

    def tr(adapter)
      ret = case @@store
        when :yaml
          YAMLadapter.get_trans
        when :plain
          ret = @@location
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
      @@store = str.to_sym
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
      @@locale = loc.to_sym
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

    def trans
      @@trans
    end
  end

  class Translation
    def initialize(hash)
      hash.each_pair do |key, value|
        value = Translation.new(value) if value.is_a?(Hash)
        key = key.to_s
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