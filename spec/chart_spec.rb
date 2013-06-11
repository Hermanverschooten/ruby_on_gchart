require File.expand_path(File.dirname(__FILE__) + '/../lib/ruby_on_gchart')

describe GoogleChart do
  it "can be initialized" do
    chart = GoogleChart::Chart.new(:type => :scatter)
    chart.type.should == 's'
    chart.height.should == 200
  end

  describe "#to_url" do
    it "renders a valid url for google chart" do
      GoogleChart::Chart.new(:datas => [50, 25]).to_url.should =~ /http:\/\/chart.apis.google.com\/chart\?(.*?)/
    end
    it "renders a valid url for google chart with text_unscaled" do
      url = GoogleChart::Chart.new({
        :type => :pie,
        :height => 100,
        :width => 50,
        :encoding => :text_unscaled,
        :datas => [1203, 288, 2364, 9, 14, 35, 821, 19, 50, 30],
        :colors => ['f4a460', 'ffff00', 'ff1493', '63B8FF', '4EEE94', '0000ff', '00ff00', 'ff0000'],
        :title => "TEST",
        :chbh => "a",
        :chts => "008000,14",
        :chf => "bg,s,00000000",
        :chdlp => "b",
        :legend => ["a","b","c","d","e","f","g","h","i","j"]
      }).to_url
      url.should =~ /http:\/\/chart.apis.google.com\/chart\?(.*?)/
      expect {URI.parse(url)}.not_to raise_error
    end
  end

  describe "#to_file" do
    it "saves the generated image to a given file" do
      path = 'gchart.png'
      GoogleChart::Chart.new(:datas => [50, 25]).to_file(path)
      File.exists?(path).should == true
      File.unlink(path)    
    end
  end

  describe "#to_image" do
    it "returns the image" do
      GoogleChart::Chart.new(:datas => [50, 25]).to_image.should =~ /PNG\r\n/
    end
  end
end
