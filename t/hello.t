use Test::Nginx::Socket 'no_plan';

log_level 'warn';

run_tests();

__DATA__

=== TEST 1: hello, world
This is just a simple demonstration of the
echo directive provided by ngx_http_echo_module.
--- config
location = /t {
    echo "hello, world!";
}
--- request
GET /t
--- response_body
hello, world!
--- error_code: 200

=== TEST 2: hello from LUA
This is just a simple demonstration of the
echo directive provided by ngx_http_echo_module.
--- http_config
    lua_package_path "./lua/resty/?.lua;;";
--- config
location = /t {
    content_by_lua_block {
        local hello = require "hello"
        ngx.say(hello.say_hello())
    }
}
--- request
GET /t
--- response_body
Hello from LUA
--- error_code: 200
