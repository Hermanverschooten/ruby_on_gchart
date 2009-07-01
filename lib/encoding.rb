module GoogleChart
  class Encoding
    
    def self.array_max(datas)
      max = 0
      datas.each do |d|
        max = array_max(d) if d.is_a?(Array) and array_max(d) > max
        max = d if !d.is_a?(Array) and d > max
      end

      return max
    end
    
    def self.linearize(datas)
      return false if !datas.is_a?(Array)

      # We calculate the max
      max = 0
      datas.each { |d| max = d if !d.is_a?(Array) and max < d }

      tmp = Array.new
      datas.each do |d|
        if d.is_a?(Array)
          tmp << linearize(d)
        else
          tmp << ((d.to_f/max.to_f)*100).to_i if max > 0
          tmp << 0 if max <= 0
        end
      end

      tmp
    end
    
    SIMPLE_ENCODING_SOURCE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'.freeze
    SIMPLE_ENCODING_SIZE_MINUS_ONE = SIMPLE_ENCODING_SOURCE.size - 1
    def self.simple_encode(datas)
      max = array_max(datas)
      encoded= ''

      datas.each do |value|
        if value.is_a?(Array)
          encoded << simple_encode(value) + ','
        else
          if value.respond_to?(:integer?) && value >= 0
            encoded << SIMPLE_ENCODING_SOURCE[SIMPLE_ENCODING_SIZE_MINUS_ONE * value / max]
          else
            encoded << '_'
          end
        end
      end

      encoded
    end

    def self.text_encode(datas)
      ret = ''

      i = 0
      datas.each do |d|
        if d.is_a?(Array)
          ret << '|' if i > 0
          ret << text_encode(d)
        else
          ret << ',' if i > 0
          ret << d.to_s
        end
        i += 1
      end    
      ret
    end
  end
end