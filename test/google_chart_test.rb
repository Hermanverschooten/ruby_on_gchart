require 'test_helper'

class GoogleChartTest < ActiveSupport::TestCase  
  def test_initialize_datas
    d = GoogleChart.new(:type => :scatter)
    assert_equal 's', d.type
    assert_equal 200, d.height
  end
  
  def test_to_url
    d = GoogleChart.new(:datas => [50, 25]).to_url
    assert_match(/http:\/\/chart.apis.google.com\/chart\?(.*?)/, d)
  end
  
  def test_to_file
    path = 'gchart.png'
    
    d = GoogleChart.new(:datas => [50, 25]).to_file(path)
    
    assert File.exists?(path)
    File.unlink(path)
  end
  
  def test_simple_encoding
    d = GoogleChart.new(:datas => [50, 25], :encoding => :simple).datas
    assert_match(/s:([0-z\_]+)/i, d)
  end
  def test_text_encoding
    d = GoogleChart.new(:datas => [50, 25]).datas
    assert_match(/t:([0-9]+)/, d)
  end
  
  def test_linearize
    datas = [50, 25]
    d = GoogleChart.new.send :linearize, datas
    
    assert_equal 100.0, d[0]
    assert_equal 50.0, d[1]
  end
  
  def test_linearize_multi_dimensionnal
    datas = [50, 25, [50, 25]]
    d = GoogleChart.new.send :linearize, datas
    
    assert_equal 100.0, d[0]
    assert_equal 50.0, d[1]
    
    assert_equal 100.0, d[2][0]
    assert_equal 50.0, d[2][1]
  end
end
