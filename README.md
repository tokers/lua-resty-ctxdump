Name
====

lua-resty-ctxdump - stash and apply the ngx.ctx, avoiding being destoried after Nginx internal redirect happens.

![Build Status](https://travis-ci.org/tokers/lua-resty-ctxdump.svg?branch=master)

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Synopsis](#synopsis)
* [Methods](#methods)
    * [stash_ngx_ctx](#stash_ngx_ctx)
    * [apply_ngx_ctx](#apply_ngx_ctx)
* [Author](#author)
* [Copyright and License](#copyright-and-license)
* [See Also](#see-also)

Status
======

Probably production ready in most cases, though not yet proven in the wild.  Please check the issues list and let me know if you have any problems / questions.

Synopsis
========

```lua

location /t1 {
    set $ctx_ref = "";
    content_by_lua_block {
         local ctxdump = require "resty.ctxdump"
         ngx.ctx = {
             Date = "Wed May  3 15:18:04 CST 2017",
             Site = "unknown"
        }
        ngx.var.ctx_ref = ctxdump.stash_ngx_ctx()
        ngx.exec("/t2")
    }
}

location /t2 {
    internal;
    content_by_lua_block {
         local ctxdump = require "resty.ctxdump"
         ngx.ctx = {
             Date = "Wed May  3 15:18:04 CST 2017",
             Site = "unknown"
        }
        ngx.ctx = ctxdump.apply_ngx_ctx(ngx.var.ctx_ref)
        ngx.say("Date: " .. ngx.ctx["Date"] .. " Site: " .. ngx.ctx["Site"])
    }
}

```

Methods
=======

stash_ngx_ctx
-------------

**syntax:** *ref = stash_ngx_ctx()* <br>
**phase:** *init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*,
    content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*,
    ngx.timer.\*, balancer_by_lua\* 
    
Reference the `ngx.ctx`, returns an anchor(a new reference maintained by lua-resty-ctxdump).

Note: `stash_ngx_ctx` and `apply_ngx_ctx` must be called in pairs, otherwise memory leak will happen! See [apply_ngx_ctx](#apply_ngx_ctx).

apply_ngx_ctx
-------------

**syntax:** *old_ngx_ctx = apply_ngx_ctx(ref)* <br>
**phase:** *init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*,
    content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*,
    ngx.timer.\*, balancer_by_lua\* 
    
fetch the old `ngx.ctx` with the anchor returns from `stash_ngx_ctx `. After that, the anchor will be out of work.

Note: `stash_ngx_ctx` and `apply_ngx_ctx ` must be called in pairs, otherwise memory leak will happen! See [stash_ngx_ctx](#stash_ngx_ctx).


Author
======

Alex Zhang(张超) tokers@apache.org, @api7.ai.


Copyright and License
=====================

The bundle itself is licensed under the 2-clause BSD license.

Copyright (c) 2017-2021, Alex Zhang.

This module is licensed under the terms of the BSD license.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

See Also
========

* upyun-resty: https://github.com/upyun/upyun-resty
