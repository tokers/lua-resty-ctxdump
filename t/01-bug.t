use lib 'lib';
use Test::Nginx::Socket 'no_plan';

repeat_each(2);
run_tests();

__DATA__

=== TEST 1: memo will be swell.

--- config

location = /t1 {
    set $ctx_ref "";
    content_by_lua_block {
        local ctxdump = require "resty.ctxdump"
        ngx.ctx = {
            today = "wednesday",
            launch = "steak",
            drink = "wine",
        }

        ngx.var.ctx_ref = ctxdump.stash_ngx_ctx()
        ngx.exec("/t2")
    }
}

location = /t2 {
    content_by_lua_block {
        local ctxdump = require "resty.ctxdump"
        ngx.ctx = ctxdump.apply_ngx_ctx(ngx.var.ctx_ref)
        ngx.say("ref is ", ngx.var.ctx_ref)
        ngx.var.ctx_ref = ""
    }
}

--- request
GET /t1

--- error_code: 200

--- response_body
ref is 1

--- request
GET /t1

--- error_code: 200

--- response_body
ref is 1
