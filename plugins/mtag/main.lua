local ngx = ngx

local _M = {}

function _M.init_worker()
    local websocket = require("mtag.websocket"):new("controller:81", true)
    local protocol = require("mtag.protocol"):new()
    websocket:set_protocol(protocol)
    websocket:run()
end


function _M.rewrite()
    local service = services["my_service"]
    local res, err = service:resolve(ngx.var.request_method, ngx.var.uri)
    ngx.status = 200
    ngx.say(res["permission"]) -- return configuration identifier
    ngx.exit(ngx.HTTP_OK)
end

return _M
