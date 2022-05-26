require 'minitest/autorun'
require_relative 'bowling'

class GateTest < Minitest::Test
  def test_get_point
    assert 139, get_point('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert 164, get_point('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert 107, get_point('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert 134, get_point('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert 144, get_point('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert 300, get_point('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
