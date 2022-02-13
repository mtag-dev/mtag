# MTAG

Under development


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

#### Service

- [x] Ignore trailing slashes
- [x] Superuser permission
- [x] Path validators
- [x] Locations
- [ ] Configuration failure notification
- [ ] Maintenance mode
- [ ] Structured config
- [ ] Dependency injection declaration

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