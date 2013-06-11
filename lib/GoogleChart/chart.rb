module GoogleChart
  class Chart
    attr_accessor :height, :width, :encoding
    attr_writer :type, :datas

  
    def initialize(params = {})
      @options = {}
      params = {
        :type => :pie_3d,
        :height => 200,
        :width => 600,
        :encoding => nil,
        :datas => Array.new
      }.merge! params
    
      params.each do |k,v|
        self.send k.to_s + '=', v
      end
    end

    def google_options
      {
        :title => ["chtt",:single_value],
        :labels => ["chl", :single_piped_array],
        :legend => ["chdl", :single_piped_array],
        :legend_position => ["chdlp", :single_value],
        :colors => ["chco", :single_comma_array],
        :axis_type => ["chxt", :single_comma_array],
        :axis_labels => ["chxl", :multi_indexed_comma_array],
        :axis_range => ["chxr", :multi_indexed_comma_array],
        :axis_styles => ["chxs", :multi_indexed_comma_array],
        :axis_tick_length => ["chxtc", :multi_indexed_array],
        :data_labels => ["chm", :multi_piped_array],
        :data_scaling => [:chds, :single_comma_array]
      }

    end
    alias_method :old_method_missing, :method_missing

    def method_missing(method, *args)
      if method.to_s.ends_with?("=")
        @options[method.to_s.chop.to_sym] = args.first and return if args.is_a?(Array) && args.length==1
        @options[method.to_s.chop.to_sym] = args
      else
        old_method_missing(method)
      end
    end

    def render_option(opt,value)
      goption = google_options[opt]
      return value.to_query(opt) unless goption

      return (case goption[1]
        when :single_value
          value
        when :single_piped_array
          raise "#{opt} expects an array" unless value.is_a?(Array)
          value.join("|")
        when :single_comma_array
          raise "#{opt} expects an array" unless value.is_a?(Array)
          value.join(",")
        when :multi_indexed_piped_array
          raise "#{opt} expects an array" unless value.is_a?(Array)
          if value.first.is_a?(Array)
            n=-1
            value.map do |v|
              "#{n+=1}:|#{v.join("|")}"
            end.join("|")
          else
            "0:|#{value.join("|")}"
          end
        when :multi_indexed_comma_array
          raise "#{opt} expects an array" unless value.is_a?(Array)
          if value.first.is_a?(Array)
            n=-1
            value.map do |v|
              "#{n+=1},#{v.join(",")}"
            end.join("|")
          else
            "0,#{value.join(",")}"
          end
        when :multi_indexed_array
          raise "#{opt} expects an array" unless value.is_a?(Array)
          n=-1
          value.map do |v|
            "#{n+=1},#{v}"
          end.join("|")
        when :multi_piped_array
          raise "#{opt} expects an array" unless value.is_a?(Array)
          if value.first.is_a?(Array)
            value.map do |v|
              v.join(",")
            end.join("|")
          else
            value.join(",")
          end
        else
          value
        end).to_query(goption[0])
    end

    def render_options
      @options.map do |k,v|
        "&#{render_option(k,v)}"
      end.join('') if @options
    end
  
    def to_url
      raise "No data has been defined" unless @datas.any?

      'http://chart.apis.google.com/chart?cht=' + type + '&chs=' + size + '&' + datas.to_query("chd")  + render_options
    end
    def to_file(path)
      url = URI.parse to_url
    
      Net::HTTP.start(url.host) { |http|
        resp = http.get(url.path)
        open(path, 'wb') { |file| file.write(resp.body) }
      }
    end

    def to_image
      url = URI.parse to_url

      resp = Net::HTTP.get(url)
      return resp
    end
  
    def size
      width.to_s + 'x' + height.to_s
    end
    def datas
      case encoding
      when :simple then return 's:' + GoogleChart::Encoding.simple_encode(GoogleChart::Encoding.linearize(@datas))
      when :text then 't:' + GoogleChart::Encoding.text_encode(GoogleChart::Encoding.linearize(@datas))
      when :text_unscaled
        maxdata = [0,GoogleChart::Encoding.array_max(@datas)]
        if @datas.first.is_a?(Array)

          @options[:data_scaling] = maxdata * @datas.length
        else
          @options[:data_scaling] = maxdata
        end
        return 't:' + GoogleChart::Encoding.text_encode(@datas)
      else return 't:' + GoogleChart::Encoding.text_encode(@datas)
      end
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
