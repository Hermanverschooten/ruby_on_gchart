require File.expand_path(File.dirname(__FILE__) + '/../lib/GoogleChart')

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
