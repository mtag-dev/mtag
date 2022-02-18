-- Trim starting and ending spaces from string
-- @param s string to be trimmed
local function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Get boolean value from ENV variable
-- @param variable ENV variable name
-- @param default for return if `variable` isn't set or have wrong format
local function get_bool(variable, default)
  -- TODO: log.WARN if ENV variable exists but not a valid boolean
  local val = trim(os.getenv(variable) or ""):lower()

  if val == "true" then
    return true
  elseif val == "false" then
    return false
  else
    return default
  end
end

-- Get integer value from ENV variable
-- @param variable ENV variable name
-- @param default for return if `variable` isn't set or have wrong format
local function get_int(variable, default)
  -- TODO: log.WARN if ENV variable exists but not a valid integer
  return tonumber(trim(os.getenv(variable) or "")) or default
end

-- Get hostname value from ENV variable like `<hostname>:<port>` or `<hostname>`
-- @param variable ENV variable name
local function get_hostname(variable)
  local from_env = os.getenv(variable)
  if from_env then
    return string.match(from_env, "([^:]+):[0-9]+") or from_env
  end
end

-- Get port value from ENV variable like `<hostname>:<port>`
-- @param variable ENV variable name
local function get_port(variable)
  return tonumber(trim(string.match(os.getenv(variable) or "", "[^:]+:([0-9]+)") or ""))
end


local controller_ssl = get_bool("MTAG_CONTROLLER_SSL", true)
local controller_default_port = controller_ssl and 443 or 80


local _M = {
  controller = {
    hostname = get_hostname("MTAG_CONTROLLER_HOST"),
    port = get_port("MTAG_CONTROLLER_HOST") or controller_default_port,
    prefix = os.getenv("MTAG_CONTROLLER_PREFIX") or "",
    secret = os.getenv("MTAG_CONTROLLER_SECRET"),
    ssl = controller_ssl,
    ssl_verify = get_bool("MTAG_CONTROLLER_SSL_VERIFY", true)
  },
  redis = {
    hostname = get_hostname("MTAG_REDIS_HOST"),
    port = get_port("MTAG_REDIS_HOST") or 6379,
    pool_size = get_int("MTAG_REDIS_POOL_SIZE", 10),
    backlog = get_int("MTAG_REDIS_BACKLOG", nil),
    timeout = get_int("MTAG_REDIS_TIMEOUT", 1),
    ssl = get_bool("MTAG_REDIS_SSL", false),
    ssl_verify = get_bool("MTAG_REDIS_SSL_VERIFY", false),
    shared_dict_failover = get_bool("MTAG_REDIS_SHARED_DICT_FAILOVER", true)
  }
}

return _M
