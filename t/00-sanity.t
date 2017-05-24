use lib 'lib';
use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: stash and apply the old ngx.ctx

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
        ngx.var.ctx_ref = ""
        ngx.say("today ", ngx.ctx["today"], " launch ", ngx.ctx["launch"],
                  " drink ", ngx.ctx["drink"])
    }
}

--- request
GET /t1

--- error_code: 200

--- response_body
today wednesday launch steak drink wine
