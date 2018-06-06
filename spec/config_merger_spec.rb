require 'minitest/autorun'
require_relative "../lib/config_merger"

describe ConfigMerger do
  it "adds new configs from xenv to result" do
    current = {"XGYVER" => "test"}
    new = {"XGYVER" => "test", "STATUS" => "running"}

    result = ConfigMerger.call(current, new)
    assert_equal(result, {"XGYVER" => "test", "STATUS" => "running"})
  end

  it "updates existing configs from xenv in result" do
    current = {"XGYVER" => "test"}
    new = {"XGYVER" => "test2"}

    result = ConfigMerger.call(current, new)
    assert_equal(result, {"XGYVER" => "test2"})
  end

  it "sets removed keys from xenv in result to nil" do
    current = {"XGYVER" => "test", "STATUS" => "running"}
    new = {"XGYVER" => "test"}

    result = ConfigMerger.call(current, new)
    assert_equal(result, {"XGYVER" => "test", "STATUS" => nil})
  end
end
