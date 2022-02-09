local ngx = ngx
local cjson = require("cjson")

local _M = {
    state = {
        authentication = {},
        service = {},
        initialized = false
    }
}

function _M.init_worker()
    local websocket = require("mtag.websocket"):new("controller:81", true)
    local protocol = require("mtag.protocol"):new(_M.state)
    websocket:set_protocol(protocol)
    websocket:run()
end


function _M.rewrite()
    local state = _M.state
    local service = state.service["my_service"]
    local res, err = service:resolve(ngx.var.request_method, ngx.var.uri)
    local no_authorized = true
    if res then
        local openidc = require("resty.openidc")
        openidc.set_logging(nil, { DEBUG = ngx.INFO })
        local ok, err = openidc.bearer_jwt_verify(state.authentication.parameters)
        if ok then
            for i, permission in pairs(ok.permissions or {}) do
                if res["permission"] == permission then
                    ngx.status = 200
                    ngx.say(permission)
                    ngx.exit(ngx.HTTP_OK)
                    return
                end
            end
            ngx.exit(ngx.HTTP_FORBIDDEN)
        else
            ngx.exit(ngx.HTTP_UNAUTHORIZED)
        end
    else
        ngx.exit(ngx.HTTP_NOT_FOUND)
    end
end

return _M
