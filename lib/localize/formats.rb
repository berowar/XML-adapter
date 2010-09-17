module Localize
  class Formats
    class << self

      # Based on snippet in http://snippets.dzone.com/posts/show/2472
      def phone(str, format)
        require 'strscan'
        pattern = Localize.trans[:formats]['phone'][format.to_s]
        slots = pattern.count('#')
        source = str.to_s

        if source.length < slots
          keepCount = source.length
          leftmost, rightmost = 0, pattern.length - 1

          leftmost = (1...keepCount).inject(pattern.rindex('#')) {
              |leftmost, n| pattern.rindex('#', leftmost - 1) }

          pattern = pattern[leftmost..rightmost]
        end

        scanner = ::StringScanner.new(pattern)
        sourceIndex = 0
        result = ''
        fixRegexp = Regexp.new(Regexp.escape('#'))
        while not scanner.eos?
          if scanner.scan(fixRegexp) then
            result += source[sourceIndex].chr
            sourceIndex += 1
          else
            result += scanner.getch
          end
        end
        result
      end

      def date(source, format)
        locale = Localize.trans[:formats]['date']
        format = locale['format'][format.to_s]

        if Localize.store == :xml
          format.gsub!(/%a/, locale['day_names']['short'].split[source.wday])
          format.gsub!(/%A/, locale['day_names']['full'].split[source.wday])
          format.gsub!(/%b/, locale['mon_names']['short'].split[source.mon-1])
          format.gsub!(/%B/, locale['mon_names']['full'].split[source.mon-1])
        else
          format.gsub!(/%a/, locale['day_names']['short'][source.wday])
          format.gsub!(/%A/, locale['day_names']['full'][source.wday])
          format.gsub!(/%b/, locale['mon_names']['short'][source.mon-1])
          format.gsub!(/%B/, locale['mon_names']['full'][source.mon-1])
        end

        source.strftime(format)
      end

      # Based on snippet on rubygarden
      def number(num)
        locale = Localize.trans[:formats]['number']
        separator = locale['separator'] || ''
        decimal_point = locale['dec_point'] || '.'
        num_parts = num.to_s.split('.')
        x = num_parts[0].reverse.scan(/.{1,3}/).join(separator).reverse
        x << decimal_point + num_parts[1]
      end
    end
  end
end