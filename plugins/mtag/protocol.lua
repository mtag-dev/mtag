local cjson = require("cjson.safe")
local service = require("mtag.service")

local _M = {
    version = "v1"
}

function _M:new(state)
    self.state = state
    return self
end

-- Process configuration protocol message
-- @param encoded JSON-encoded string
function _M:feed(encoded)
    local res, err = cjson.decode(encoded)
    if err then
        ngx.log(ngx.ERR, "[MTAG] JSON decode error: ", err)
        return
    end

    for i, record in pairs(res.data) do
        if record.type == "authentication" then
            self:process_authentication(record.data)
        elseif record.type == "service" then
            self:process_service(record.data)
        end
    end

    self.state.initialized = true
end

-- Single service configuration processor
-- @param data configuration data
function _M:process_service(data)
    if data.name == nil then
        ngx.log(ngx.ERR, data.name)
        return
    end

    local s = service:new()
    s:configure(data)
    self.state.service[data.name] = s
end

-- Single authentication provider configuration processor
-- @param data configuration data
function _M:process_authentication(data)
    self.state.authentication = data
end

-- Single group configuration processor
-- @param data configuration data
function _M:process_group(data)
end

return _M
