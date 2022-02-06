local shared = ngx.shared
local setmetatable = setmetatable


local _M = {
   _VERSION = '0.01'
}


local mt = {
    __index = _M
}


function _M.new(redis, dict_name)
    local self = {
        redis = redis,
        dict_name = dict_name
    }

    return setmetatable(self, mt)
end

function _M.add_rule(self, key, value, limit, window)

end

return _M