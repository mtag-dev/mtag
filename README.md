# MTAG

Under development

### Controller configuration

`MTAG_CONTROLLER_HOST` - Host and optionally port. Port defaults: non-ssl `80`, ssl `443`. 
Examples: `controller.internal`, `controller.internal:8080` 

`MTAG_CONTROLLER_PREFIX` - Adds an optional prefix to the controller path. For some complex scenarios when controller located behind additional reverse-proxy.

`MTAG_CONTROLLER_SECRET` - Secret token for authentication ingress on the controller. Will be passed to controller use query string parameter.

`MTAG_CONTROLLER_SSL` - Using of SSL connection. Defaults to `true`

`MTAG_CONTROLLER_SSL_VERIFY` - Validate of controller certificate. Defaults to `true`

### Redis configuration

`MTAG_REDIS_HOST` - Host and optionally port. Port defaults to `6379`.

`MTAG_REDIS_POOL_SIZE` - Specifies the size of the connection pool.

`MTAG_REDIS_BACKLOG` - If specified, will limit the total number of opened connections for this pool. No more connections than MTAG_REDIS_POOL_SIZE can be opened for this pool at any time.

`MTAG_REDIS_TIMEOUT` - Sets the timeout (in ms) protection for subsequent operations, including the connect method. 

`MTAG_REDIS_SSL` - If set to true, then uses SSL to connect to redis (defaults to false).

`MTAG_REDIS_SSL_VERIFY` - If set to true, then verifies the validity of the server SSL certificate (defaults to false). Note that you need to configure the lua_ssl_trusted_certificate to specify the CA (or server) certificate used by your redis server. You may also need to configure lua_ssl_verify_depth accordingly.

`MTAG_REDIS_SHARED_DICT_FAILOVER` - Use shared dict instead of redis if `MTAG_REDIS_TIMEOUT` reached or Redis is not reachable. Defaults to `true`


## Track

#### WIP (autotests yet not implemented)

- [x] Configuration protocol processing

#### TODO


#### Deployment

- [ ] Dockerfiles for OpenResty
- [ ] Dockerfiles for K8s ingress

#### Security

- [ ] Rate-limit. Planned

#### AuthN/AuthZ

- [x] IDP dynamic configuration
- [ ] Permissions/Roles/Groups definition
- [ ] JWT/OAuth/OIDC integration
- [ ] Introspection
- [ ] Groups/Roles to permissions dynamic mapping
- [ ] Get access_token from QS for WS connections

#### Service

- [x] Ignore trailing slashes
- [x] Superuser permission
- [x] Path validators
- [x] Locations
- [ ] Configuration failure notification
- [ ] Maintenance mode
- [ ] Structured config
- [ ] Dependency injection declaration
- [ ] CORS configuration

#### Service endpoints

- [ ] Services/states/maintenance

#### Protocol

- [ ] Switch to ProtoBuff instead of JSON (Pending)
- [ ] Last applied configuration version

#### Request handling

- [ ] WebSockets connector configuration (ENVs)
- [x] Resolving endpoint configuration
- [ ] Wait for configuration init in `rewrite` stage.


####

Repository files plan scratch

```shell
mtag    
|  Makefile
|
└─ examples
|  | ...
|
└─ lua  # MTAG codebase
| └─ plugins
|   └─ mtag
|      |  main.lua 
|      |  protocol.lua 
|      |  service.lua 
|      |  websocket.lua 
|      └─ test
|         | ...
|
└─ build
   |  Dockerfile.k8s
   |  Dockerfile.resty
   |  ...

```