package = "lua-resty-ctxdump"
version = "0.1-0"
source = {
   url = "git://github.com/tokers/lua-resty-ctxdump",
   tag = "v0.1"
}

description = {
   summary = "Stash and apply the ngx.ctx, avoiding being destoried after Nginx internal redirect happens",
   homepage = "https://github.com/tokers/lua-resty-ctxdump",
   license = "2-clause BSD license",
   maintainer = "Chao Zhang <tokers@apache.org>"
}

build = {
   type = "builtin",
   modules = {
      ["resty.ctxdump"] = "lib/resty/ctxdump.lua"
   }
}
