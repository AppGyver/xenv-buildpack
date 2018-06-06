require "net/http"
require "json"

require_relative "./settings"

class HerokuApp
  class RuntimeError < StandardError; end
  HEROKU_API = "https://api.heroku.com".freeze

  def initialize(token, app)
    @token = token || ENV["XENV_HEROKU_PLATFORM_API_KEY"]
    @app = app || ENV["XENV_HEROKU_APP_NAME"]

    raise "Heroku app name missing" unless @app
    raise "Heroku platform token missing" unless @token
  end

  def envs
    uri = URI("https://api.heroku.com/apps/#{@app}/config-vars")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = {
      "Authorization" => "Bearer #{@token}",
      "Accept" => "application/vnd.heroku+json; version=3",
    }

    res = http.get(uri.request_uri, headers)
    case res
    when Net::HTTPSuccess
      strip_blacklisted_envs(JSON.parse(res.body))
    else
      raise XEnv::RuntimeError.new("Could not fetch Heroku config: code: #{res.code} msg:#{res.message} body:#{res.body}")
    end
  end

  # Sets the new config block.
  # Remove old config keys by setting its values to nil
  def set_envs(envs)
    envs = strip_blacklisted_envs(envs)
    if xenv_dryrun
      puts "\e[0;33m!    Warning: Dry-run mode enabled.\e[0m"
      puts "\e[0;33m!    Not updating Heroku config.\e[0m"
      return
    end
    uri = URI("https://api.heroku.com/apps/#{@app}/config-vars")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = {
      "Authorization" => "Bearer #{@token}",
      "Content-Type" => "application/json",
      "Accept" => "application/vnd.heroku+json; version=3",
    }

    request = Net::HTTP::Patch.new(uri.request_uri, headers)
    request.body = envs.to_json
    res = http.request(request)

    case res
    when Net::HTTPSuccess
      puts "Successfully updated #{@app} Heroku config"
      JSON.parse(res.body)
    else
      puts res.body
      raise XEnv::RuntimeError.new("Could not update Heroku config")
    end
  end

  private
  def strip_blacklisted_envs(envs)
    Settings::RESERVED_ENVS.each do |e|
      envs.delete(e)
    end
    envs
  end

  def xenv_dryrun
    ENV["XENV_RUN"] != "true"
  end
end
