require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "配球共有"
    assert_equal full_title("Help"), "Help | 配球共有"
  end
end
