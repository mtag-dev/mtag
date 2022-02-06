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


function WebSocket:new(host, insecure)
    self.host = host
    self.insecure = insecure
    return self
end

function WebSocket:set_protocol(protocol)
    self.protocol = protocol
end

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
