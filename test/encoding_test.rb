require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/google_chart')

class GoogleChartTest < ActiveSupport::TestCase  
  
  def test_simple_encoding
    d = GoogleChart::Encoding.simple_encode([50, 25])
    assert_match(/([0-z\_]+)/i, d)
  end
  def test_simple_encoding_multi_dimensionnal
    d = GoogleChart::Encoding.simple_encode([50, 25, [50, 25]])
    assert_match(/([0-z\_]+)|([0-z\_]+)/i, d)
  end
  
  def test_text_encoding
    d = GoogleChart::Encoding.text_encode([50, 25])
    assert_match(/([0-9]+)/, d)
  end
  def test_text_encoding_multi_dimensionnal
    d = GoogleChart::Encoding.text_encode([50, 25, [50, 25]])
    assert_match(/([0-9]+)|([0-9]+)/i, d)
  end
  
  def test_get_max_values
    d = GoogleChart::Encoding.array_max([50, 100])
    assert_equal 100, d
  end
  
  def test_get_max_values_multi_dimensionnal
    d = GoogleChart::Encoding.array_max([[90, 80], [100, 70]])
    assert_equal 100, d
  end
  
  def test_linearize
    datas = [50, 25]
    d = GoogleChart::Encoding.linearize(datas)
    
    assert_equal 100.0, d[0]
    assert_equal 50.0, d[1]
  end
  
  def test_linearize_multi_dimensionnal
    datas = [50, 25, [50, 25]]
    d = GoogleChart::Encoding.linearize(datas)
    
    assert_equal 100.0, d[0]
    assert_equal 50.0, d[1]
    
    assert_equal 100.0, d[2][0]
    assert_equal 50.0, d[2][1]
  end
end
