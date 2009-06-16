class GoogleChart
  attr_accessor :height, :width, :encoding
  attr_writer :type, :datas, :labels
  
  def initialize(params = {})
    params = {
      :type => :pie_3d,
      :height => 200,
      :width => 600,
      :encoding => nil,
      :datas => Array.new,
      :labels => Array.new
    }.merge! params
    
    params.each do |k,v|
      self.send k.to_s + '=', v
    end
  end
  
  def to_url
    'http://chart.apis.google.com/chart?cht=' + type + '&chs=' + size + '&chd=' + datas + '&chl=' + labels
  end
  def to_file(path)
    url = URI.parse to_url
    
    Net::HTTP.start(url.host) { |http|
      resp = http.get(url.path)
      open(path, 'wb') { |file| file.write(resp.body) }
    }
  end
  
  def size
    if width > height
      width = 1000 if width > 1000
      height = 300000 - width if height * width > 300000
    else
      height = 1000 if height > 1000
      width = 300000 - height if width * height > 300000
    end
    
    width.to_s + 'x' + height.to_s
  end
  def datas
    datas = linearize(@datas)    
    case encoding
      when :simple then return 's:' + simple_encode(datas)
      else return 't:' + text_encode(datas)
    end
  end
  def labels
    @labels.join('|') || ''
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
  
  private  
  def linearize(datas)
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
  def simple_encode(datas)
    max = 0
    datas.each { |d| max = d if !d.is_a?(Array) and max < d }
    encoded= ''
    
    datas.each do |value|
      if value.is_a?(Array)
        encoded << simple_encode(value) + '|'
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
  
  def text_encode(datas)
    ret = ''
    datas.each do |d|
      if d.is_a?(Array)
        ret << text_encode(d) + '|'
      else
        ret << d.to_s + ','
      end
    end
    
    ret
  end
end
