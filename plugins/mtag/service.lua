local Service = {}

local pairs = pairs
local squall_router = require("squall_router")

-- Create new service
-- @param name Service name
function Service:new()
    return self
end

-- Configure service instance
-- @param data Configuration data
function Service:configure(data)
    local router = squall_router.new_router()
    local settings = {}

    for alias, regex in pairs(data.validators) do
        router:add_validator(alias, regex)
    end

    for index, endpoint in pairs(data.endpoints) do
        router:add_route(
            endpoint.method,
            endpoint.path,
            index
        )
        settings[index] = endpoint
    end

    self.router = router
    self.settings = settings
end

-- Route resolving method.
-- Returns endpoint configuration or nil
-- @param method Request method
-- @param path Request path
function Service:resolve(method, path)
    local res, err = self.router:resolve(method, path)
    if res ~= nil then
        return self.settings[res[1]], nil
    end
end

return Service
