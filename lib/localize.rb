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

      ret = case @@store
        when :yaml
          YAMLadapter.get_trans
        when :plain
          @@location
        else
          raise "Adapter not avalaible: #{adapter}"
      end
      @@trans = {
        :text => Translation.new(ret['text']),
        :formats => ret['formats']
      }
    end

    def translate
      load unless @@trans
      @@trans[:text]
    end

    def localize(source, format = :full)
      load unless @@trans

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

    alias :l :localize

    def phone(source, format = :full)
      load unless @@trans

      fone = if source.is_a?(Integer)
        source
      elsif source.is_a?(String)
        source.gsub(/[\+., -]/, '').trim.to_i
      elsif source.is_a?(Float)
        source.to_s.gsub('.', '').to_i
      else
        raise "Format not recognize"
      end
      Formats.phone(fone, format)
    end

    alias :f :phone

    def reset!
      @@trans = nil
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
          define_method("#{key}") do |*args|
            str = instance_variable_get("@#{key}")
            if args.length > 0
              _interpolate(str, args)
            else
              str
            end
          end
        end
      end
    end

    def method_missing(name, *params)
      MissString.new('Translation missing: '+name.to_s)
    end

    private
      def _interpolate(string, args)
        args.length.times do |i|
          string.gsub!(/\$\{#{i+1}\}/, args[i])
        end
        string
      end
  end

  class MissString < String
    def method_missing(name, *params)
      self << '.' + name.to_s
    end
  end
end