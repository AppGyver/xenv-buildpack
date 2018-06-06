require "net/http"
require "json"
require "cgi"

require_relative "./settings"

class XEnv

  class RuntimeError < StandardError; end

  HEROKU_KEY_NAME = "XENV_HEROKU_PLATFORM_API_KEY".freeze
  attr_reader :base_url, :token, :constraints

  def initialize(opts)
    @base_url = opts[:base_url]
    @token = opts[:token]

    @constraints = opts[:constraints]
  end

  def self.from_uri(uri = ENV["XENV_URL"])
    uri = URI.parse(uri)
    params = CGI::parse(uri.query)
    constraints = {}

    # querystrings can have the same key multiple times
    # but we are interested in only the first occurrence
    params.keys.each do |k|
      constraints[k.to_sym] = params[k].first
    end

    token = constraints.delete :token
    raise XEnv::RuntimeError.new("XEnv url is missing the token parameter!") unless token

    new(
      base_url: "#{uri.scheme}://#{uri.host}",
      token: token,
      constraints: params
    )
  end

  def query_params
    {token: @token}.merge @constraints
  end

  def platform
    @constraints[:platform]
  end

  def xgyver
    @constraints[:xgyver]
  end

  def app
    @constraints[:app]
  end

  def heroku_platform_api_key
    fetch_envs[HEROKU_KEY_NAME]
  end

  def envs
    strip_blacklisted_envs(fetch_envs)
  end

  def fetch_envs
    @__envs ||= begin
      uri = URI(@base_url)
      uri.path = "/envs.json"
      uri.query = URI.encode_www_form(query_params)

      res = Net::HTTP.get_response(uri)

      if res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)
      else
        puts "Response status code: #{res.code}"
        puts "Response body: "
        puts res.body
        raise XEnv::RuntimeError.new("Could not fetch XEnv config")
      end
    end
  end

  private
  def strip_blacklisted_envs(envs)
    Settings::RESERVED_ENVS.each do |e|
      envs.delete(e)
    end
    envs
  end
end
