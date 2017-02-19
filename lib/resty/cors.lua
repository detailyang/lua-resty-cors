-- @Author: detailyang
-- @Date:   2016-10-10 15:45:33
-- @Last Modified by:   detailyang
-- @Last Modified time: 2017-02-19 13:29:41

-- https://www.w3.org/TR/cors/

local re_match = ngx.re.match

local _M = { _VERSION = '0.1.0'}

local Origin = 'Origin'
local AccessControlAllowOrigin = 'Access-Control-Allow-Origin'
local AccessControlExposeHeaders = 'Access-Control-Expose-Headers'
local AccessControlMaxAge = 'Access-Control-Max-Age'
local AccessControlAllowCredentials = 'Access-Control-Allow-Credentials'
local AccessControlAllowMethods = 'Access-Control-Allow-Methods'
local AccessControlAllowHeaders = 'Access-Control-Allow-Headers'

local mt = { __index = _M }

local allow_hosts = {}
local allow_headers = {}
local allow_methods = {}
local expose_headers = {}
local max_age = 3600
local allow_credentials = true
local join = table.concat


function _M.allow_host(host)
    allow_hosts[#allow_hosts + 1] = host
end

function _M.allow_method(method)
    allow_methods[#allow_methods + 1] = method
end

function _M.allow_header(header)
    allow_headers[#allow_headers + 1] = header
end

function _M.expose_header(header)
    expose_headers[#expose_headers + 1] = header
end

function _M.max_age(age)
    max_age = age
end

function _M.allow_credentials(credentials)
    allow_credentials = credentials
end

function _M.run()
    local origin = ngx.req.get_headers()[Origin]
    if not origin then
        return
    end

    local matched = false
    for k, v in pairs(allow_hosts) do
        local from, to, err = ngx.re.find(origin, v, "jo")
        if from then
            matched = true
        end
    end

    if matched == false then
        return
    end

    ngx.header[AccessControlAllowOrigin] = origin
    ngx.header[AccessControlMaxAge] = max_age

    if #expose_headers >= 0 then
        ngx.header[AccessControlExposeHeaders] = join(expose_headers, ',')
    end

    if #allow_headers >= 0 then
        ngx.header[AccessControlAllowHeaders] = join(allow_headers, ',')
    end

    if #allow_methods >= 0 then
        ngx.header[AccessControlAllowMethods] = join(allow_methods, ',')
    end

    if allow_credentials == true then
        ngx.header[AccessControlAllowCredentials] = "true"
    else
        ngx.header[AccessControlAllowCredentials] = "false"
    end
end

return _M
