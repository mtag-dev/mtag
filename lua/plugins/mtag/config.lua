local validation = require("resty.validation")


local function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end


local function get_bool(name, default)
  local val = trim(os.getenv(name) or ""):lower()

  if val == "true" then
    return true
  elseif val == "false" then
    return false
  else
    return default
  end
end


local function get_int(name, default)
  return tonumber(trim(os.getenv(name) or "")) or default
end


local _M = {
  controller = {
    host = os.getenv("MTAG_CONTROLLER_HOST"),
    prefix = os.getenv("MTAG_CONTROLLER_PREFIX") or "",
    secret = os.getenv("MTAG_CONTROLLER_SECRET"),
    ssl = get_bool("MTAG_CONTROLLER_SSL", true),
    ssl_verify = get_bool("MTAG_CONTROLLER_SSL_VERIFY", true)
  },
  redis = {
    host = os.getenv("MTAG_REDIS_HOST"),
    pool_size = get_int("MTAG_REDIS_POOL_SIZE", 10),
    backlog = get_int("MTAG_REDIS_BACKLOG", nil),
    timeout = get_int("MTAG_REDIS_TIMEOUT", 1),
    ssl = get_bool("MTAG_REDIS_SSL", false),
    ssl_verify = get_bool("MTAG_REDIS_SSL_VERIFY", false),
    shared_dict_failover = get_bool("MTAG_REDIS_SHARED_DICT_FAILOVER", true)
  }
}

return _M
