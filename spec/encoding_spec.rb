require File.expand_path(File.dirname(__FILE__) + '/../lib/ruby_on_gchart')

describe GoogleChart::Encoding do
  it "can do a simple encoding" do
  	GoogleChart::Encoding.simple_encode([50,25]).should =~ /([0-z\_]+)/i
  end

  it "can do multi dimensional encodings" do
  	GoogleChart::Encoding.simple_encode([50,25,[50,25]]).should =~ /([0-z\_]+)|([0-z\_]+)/i
  end

  it "encodes text" do
    GoogleChart::Encoding.text_encode([50,25]).should =~ /([0-9]+)|([0-9]+)/i
  end

  it "gets the maximum value out of an array" do
  	GoogleChart::Encoding.array_max([50,100]).should == 100
  end

  it "gets the maximum value out of a multi dimensional array" do
  	GoogleChart::Encoding.array_max([90,80,[100,70]]).should == 100
  end

  it "linearizes an array" do
    datas = [50,25]
    GoogleChart::Encoding.linearize(datas).should == [100.0, 50.0]
  end

  it "linearizes a multi dimensional array" do
    datas = [50,25,[50,25]]
    GoogleChart::Encoding.linearize(datas).should == [100.0, 50.0,[100.0,50.0]]
  end

end