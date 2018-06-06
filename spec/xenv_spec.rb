require 'minitest/autorun'
require_relative "../lib/xenv"

describe XEnv do
  describe ".from_uri" do
    it "parses the base_url and query params" do
      xenv = XEnv.from_uri("http://example.com?token=test&platform=heroku&app=someapp&xgyver=local")
      assert_equal "test", xenv.token
      assert_equal xenv.platform, "heroku"
      assert_equal xenv.app, "someapp"
      assert_equal xenv.xgyver, "local"
      assert_equal xenv.base_url, "http://example.com"
    end
  end
end
