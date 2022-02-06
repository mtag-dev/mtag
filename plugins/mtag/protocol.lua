
-- switch to cjson safe
local cjson = require("cjson")


local _M = {
    version = "v1"
}

function _M:new(settings)
    self.settings = settings
    return self
end

function _M:feed(encoded)
    local decoded = cjson.decode(encoded)
    for i, record in pairs(decoded.data) do
        if record.type == "service" then
            self:process_service(record.data)
        end
    end
end

function _M:process_service(data)
    ngx.log(ngx.ERR, data.name)
end

function _M:process_idp(data)
end

function _M:process_group(data)
end

return _M
