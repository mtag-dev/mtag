use Test::Nginx::Socket 'no_plan';

log_level 'warn';

run_tests();

__DATA__

=== TEST 1: hello from LUA
This is just a simple demonstration of the
echo directive provided by ngx_http_echo_module.
--- http_config
    lua_package_path "./lua/resty/?.lua;;";
    lua_shared_dict req_dict 10m;
--- config
location = /t {
    access_by_lua_block {
        -- local value
        -- local location_settings = {}
        -- location_settings["/t"] = {
        --    allow_anonymous = true,
        --    check_permissions = false,
        -- }
        local rate_rules = {
            {
                key = "ip",
                limit = "10",
                window = "60",
                last_if_reach = true,
            },
            {
                key = "ip",
                limit = "10",
                window = "60",
                last_if_reach = true
            }
        }

        local limit = require("limit").new(nil, "req_dict")
        for i, rule in ipairs(rate_rules) do
            limit.add_rule(rule.key, nil, rule.limit, rule.window)
        end

    }
    return 200 "Hello from LUA\n";
}
--- request
GET /t
--- response_body
Hello from LUA
--- error_code: 200
