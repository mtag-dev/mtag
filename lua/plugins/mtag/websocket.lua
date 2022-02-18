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

local function build_uri(hostname, port, ssl, prefix, version)
    if ssl then
      port = port == 443 and "" or ":" .. port
      proto = "wss"
    else
      port = port == 80 and "" or ":" .. port
      proto = "ws"
    end
    local host = hostname .. port
    return proto .. "://".. host .. prefix .. "/gateway/" .. version .. "/ws"
end

-- @param config WebSocket configuration table. Example:
-- config = {
--    hostname = "controller",
--    port = 443,
--    prefix = "/controller/behind/proxy",
--    secret = "password123:D",
--    ssl = true,
--    ssl_verify = true
-- }
-- @param protocol `plugin.mtag.protocol` instance:
local function run(config, protocol)
    local client = require "resty.websocket.client"
    local uri = build_uri(
      config.hostname,
      config.port,
      config.ssl,
      config.prefix,
      protocol.version
    )

    local connect_options = { ssl_verify = config.ssl_verify }

    while true do
        local wb, err = client:new()
        local ok, err = wb:connect(uri, connect_options)
        if err then
            ngx.log(ngx.ERR, "failed to connect: " .. err)
            ngx.sleep(5)
        else
            receive(wb, protocol)
        end
    end
end


-- Create new Controller-WebSocket communication instance
-- @param ws_config WebSocket configuration table. Example:
-- ws_config = {
--    hostname = "controller",
--    port = 443,
--    prefix = "/controller/behind/proxy",
--    secret = "password123:D",
--    ssl = true,
--    ssl_verify = true
-- }
function WebSocket:new(ws_config)
    self.config = ws_config
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
            self.config,
            self.protocol
        )
    end

    ngx.timer.at(0, thread)
end

return WebSocket
