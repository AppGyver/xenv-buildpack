class Settings
  IGNORE_ENVS = [
  ].freeze

  RESERVED_ENVS = [
    "XENV_DEBUG",
    "XENV_DRYRUN",
    "XENV_HEROKU_APP_NAME",
    "XENV_HEROKU_PLATFORM_API_KEY",
    "XENV_PANIC_ON_ERROR",
    "XENV_RUN",
    "XENV_URL",
    *IGNORE_ENVS,
  ].freeze
end
