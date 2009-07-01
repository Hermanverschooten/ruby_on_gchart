require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/google_chart')

class GoogleChartTest < ActiveSupport::TestCase  
  def test_initialize_datas
    d = GoogleChart::Chart.new(:type => :scatter)
    assert_equal 's', d.type
    assert_equal 200, d.height
  end
  
  def test_to_url
    d = GoogleChart::Chart.new(:datas => [50, 25]).to_url
    assert_match(/http:\/\/chart.apis.google.com\/chart\?(.*?)/, d)
  end
  
  def test_to_file
    path = 'gchart.png'
    d = GoogleChart::Chart.new(:datas => [50, 25]).to_file(path)
    
    assert File.exists?(path)
    File.unlink(path)
  end
end
