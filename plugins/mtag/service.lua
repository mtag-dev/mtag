local Service = {}
local squall_router = require("squall_router")

function Service:new(name)
    return self
end

function Service:configure(service)
    local router = squall_router.new_router()
    local settings = {}

    for alias, regex in pairs(service.validators) do
        router:add_validator(alias, regex)
    end

    for index, endpoint in pairs(service.endpoints) do
        router:add_route(
            endpoint.method,
            endpoint.path,
            index
        )
        settings[index] = endpoint
    end

    self.router, self.settings = router, settings
end

function Service:resolve(method, path)
    local res, err = self.router:resolve(method, path)
    if res ~= nil then
        return self.settings[res[1]], nil
    end
end

return Service
