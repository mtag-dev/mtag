local _M = {
  controller = {
    host = os.getenv("MTAG_CONTROLLER_HOST"),
    prefix = os.getenv("MTAG_CONTROLLER_PREFIX"),
    secret = os.getenv("MTAG_CONTROLLER_SECRET"),
    ssl = (os.getenv("MTAG_CONTROLLER_SSL") == "true" and true or false),
    ssl_verify = (os.getenv("MTAG_CONTROLLER_SSL_VERIFY") == "true" and true or false)
  },
  redis = {
    host = os.getenv("MTAG_REDIS_HOST"),
    pool_size = os.getenv("MTAG_REDIS_POOL_SIZE"),
    backlog = os.getenv("MTAG_REDIS_BACKLOG"),
    timeout = os.getenv("MTAG_REDIS_TIMEOUT"),
    ssl = (os.getenv("MTAG_REDIS_SSL") == "true" and true or false),
    ssl_verify = (os.getenv("MTAG_REDIS_SSL_VERIFY") == "true" and true or false),
    shared_dict_failover = (os.getenv("MTAG_REDIS_SHARED_DICT_FAILOVER") == "true" and true or false),
  }
}

return _M
