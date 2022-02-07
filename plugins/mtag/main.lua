local ngx = ngx

local _M = {
    state = {
        service = {}
    }
}

function _M.init_worker()
    local websocket = require("mtag.websocket"):new("controller:81", true)
    local protocol = require("mtag.protocol"):new(_M.state)
    websocket:set_protocol(protocol)
    websocket:run()
end


function _M.rewrite()
    local service = _M.state.service["my_service"]
    local res, err = service:resolve(ngx.var.request_method, ngx.var.uri)
    if res then
        ngx.status = 200
        ngx.say(res["permission"]) -- return configuration identifier
        ngx.exit(ngx.HTTP_OK)
    else
        ngx.exit(ngx.HTTP_NOT_FOUND)
    end
end

return _M
