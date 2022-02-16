local WebSocket = {}

local function receive(wb, protocol)
    while true do
        local data, typ, err = wb:recv_frame()
        if typ == "ping" then
            local bytes, err = wb:send_pong(data)
            if not bytes then
                ngx.log(ngx.ERR, "failed to send frame: ", err)
                return
            end
        else
            if data == nil then
                return
            end
            protocol:feed(data)
        end
    end
end


local function run(host, insecure, protocol)
    local client = require "resty.websocket.client"

    while true do
        local wb, err = client:new()
        local uri = "ws://".. host .."/gateway/" .. protocol.version .. "/ws"
        local ok, err = wb:connect(uri)
        if err then
            ngx.log(ngx.ERR, "failed to connect: " .. err)
            ngx.sleep(5)
        else
            receive(wb, protocol)
        end
    end
end


-- Create new Controller-WebSocket communication instance
-- @param host Controller host
-- @param insecure Use ws:// instead of wss://
function WebSocket:new(config)
    self.host = config.host
    self.insecure = insecure
    return self
end


-- Set protocol for handling incoming messages
-- @param protocol Protocol instance
function WebSocket:set_protocol(protocol)
    self.protocol = protocol
end


-- Run WebSocket communication process
function WebSocket:run()
    local function thread()
        ngx.thread.spawn(
            run,
            self.host,
            self.insecure,
            self.protocol
        )
    end

    ngx.timer.at(0, thread)
end

return WebSocket
