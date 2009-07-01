require 'uri'
require 'net/http'
require File.expand_path(File.dirname(__FILE__) + '/encoding')

module GoogleChart
  class Chart
    attr_accessor :height, :width, :encoding
    attr_writer :type, :datas, :labels, :colors
  
    def initialize(params = {})
      params = {
        :type => :pie_3d,
        :height => 200,
        :width => 600,
        :encoding => nil,
        :datas => Array.new,
        :labels => Array.new,
        :colors => Array.new
      }.merge! params
    
      params.each do |k,v|
        self.send k.to_s + '=', v
      end
    end
  
    def to_url
      'http://chart.apis.google.com/chart?cht=' + type + '&chs=' + size + '&chd=' + datas + '&chl=' + labels + '&chco=' + colors
    end
    def to_file(path)
      url = URI.parse to_url
    
      Net::HTTP.start(url.host) { |http|
        resp = http.get(url.path)
        open(path, 'wb') { |file| file.write(resp.body) }
      }
    end
  
    def size    
      width.to_s + 'x' + height.to_s
    end
    def datas
      datas = GoogleChart::Encoding.linearize(@datas)    
      case encoding
        when :simple then return 's:' + GoogleChart::Encoding.simple_encode(datas)
        else return 't:' + GoogleChart::Encoding.text_encode(datas)
      end
    end
    def labels
      @labels.join('|') || ''
    end
    def colors
      @colors.join(',') || ''
    end  
  
    def type
      case @type
        when :line then return 'lc'
        when :sparkline then return 'ls'
        when :line_xy then return 'lxy'
      
        when :horizontal_stacked_bar then return 'bhs'
        when :vertical_stacked_bar then return 'bvs'
        when :horizontal_grouped_bar then return 'bhg'
        when :vertical_grouped_bar then return 'bvg'
      
        when :pie then return 'p'
        when :pie_3d then return 'p3'
        when :pie_concentric then return 'pc'
      
        when :venn then return 'v'
        when :scatter then return 's'
      
        when :radar then return 'r'
        when :radar_filled then return 'rs'
      
        when :meter then return 'gom'
      
        else return 'lc'
      end
    end
  end
end
