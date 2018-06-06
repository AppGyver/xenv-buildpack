# xenv-buildpack

Adds xenv binary to the application.

# Flow

This buildpack adds a utility script for fetching configuration from XEnv API
and updates the app's Heroku configuration during _deploy_.. XEnv configs will overwrite _all_ config
keys.

# Usage

1. Add buildpack to Heroku app (Use some Github account with read access to repo.)

```
heroku buildpacks:add https://github.com/AppGyver/xenv-buildpack.git
```

2. Set required ENVs by XEnv (See section below).

```
heroku config:set XENV_URL=https://your.xenv.service?token=SECRET&platform=heroku&app=your-app&xgyver=yourgyver
heroku config:set XENV_HEROKU_APP=your-app
```

3. Deploy app

4. Optional configuration

If the app should fetch configuration on every boot set:

```
heroku config:set XENV_UPDATE_ON_BOOT=true
```

# Envs

| ENV | Description |
| --- | ----------- |
|XENV_HEROKU_APP_NAME (Required)| The current apps name |
|XENV_URL (Required)| URL to XEnv API with query params for token, app & etc. |
|XENV_RUN (Optional)| Set to `true` to allow changes to Heroku config. |
|XENV_UPDATE_ON_BOOT (Optional)| Set to `true` if we should fetch XEnv config on boot. Default behaviour is just on deploy.|
|XENV_DEBUG (Optional)| Set to `true` to print debug output. |

### TODO

- Do we really want XEnv to remove any undefined keys in Heroku config?
- We need to source the latest envs during boot otherwise changes wont take effect until next run.

# License

All rights reserved.
