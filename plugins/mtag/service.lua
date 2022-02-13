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
    local errors = {}
    local res, err
    local index = 1

    -- ignore trailing slashes mode
    if data.ignore_trailing_slashes then
        router:set_ignore_trailing_slashes()
    end

    -- loading parameters validators
    for alias, regex in pairs(data.validators or {}) do
        res, err = router:add_validator(alias, regex)
        if err then
            table.insert(errors, err)
        end
    end

    -- endpoints registration
    for _, route in pairs(data.endpoints or {}) do
        res, err = router:add_route(route.method, route.path, index)

        if err then
            table.insert(errors, err)
        end

        settings[index] = route
        index = index + 1
    end

    -- locations registration
    for _, route in pairs(data.locations or {}) do
        res, err = router:add_location(route.method, route.path, index)

        if err then
            table.insert(errors, err)
        end

        settings[index] = route
        index = index + 1
    end

    if next(errors) ~= nil then
        return false, errors
    end

    self.router = router
    self.settings = settings
    self.superuser_permission = data.superuser_permission
    return true
end

-- Route resolving method.
-- Returns endpoint configuration or nil
-- @param method Request method
-- @param path Request path
function Service:resolve(method, path)
    local res, err = self.router:resolve(method, path)
    if res ~= nil then
        return self.settings[res[1]]
    end
end

return Service
