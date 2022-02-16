local ngx = ngx
local cjson = require("cjson")
local config = require("plugins.mtag.config")
local openidc = require("resty.openidc")
openidc.set_logging(nil, {DEBUG = ngx.INFO})


local _M = {
    state = {
        authentication = {},
        service = {},
        initialized = false
    }
}


local function authenticate(authentication)
    -- TODO: Check iss, aud, exp, etc, here
    return openidc[authentication.mode](authentication.parameters)
end


local function is_authorized(action_permission, superuser_permission, token_permissions)
    for i, permission in pairs(token_permissions or {}) do
        if permission == action_permission then
            return true
        elseif superuser_permission and permission == superuser_permission then
            return true
        end
    end

    return false
end

local function wait_until_state_initialized(state, timeout, check_interval)
    local _timeout = timeout or 10
    local _check_interval = check_interval or 1
    local duration = 0
    while duration < _timeout do
        ngx.sleep(_check_interval)
        duration = duration + _check_interval
        if state.initialized then
            return
        end
    end

    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end


function _M.init_worker()
    local websocket = require("plugins.mtag.websocket"):new(config.controller)
    local protocol = require("plugins.mtag.protocol"):new(_M.state)
    websocket:set_protocol(protocol)
    websocket:run()
end


function _M.rewrite()
    local state = _M.state
    if state.initialized == false then
        wait_until_state_initialized(state)
    end

    local service = state.service[ngx.var.mtag_service]
    local res, err = service:resolve(ngx.var.request_method, ngx.var.uri)
    if res then
        local ok, err = authenticate(state.authentication)
        if ok then
            if is_authorized(res["permission"], service.superuser_permission, ok.permissions) then
                return

                -- set header
                -- ngx.req.set_header(header_name, value)

                -- clear headers
                -- for header, _ in pairs(ngx.req.get_headers()) do
                --     ngx.req.clear_header(header)
                -- end
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
