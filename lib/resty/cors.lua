-- @Author: detailyang
-- @Date:   2016-10-10 15:45:33
-- @Last Modified by:   detailyang
-- @Last Modified time: 2016-10-10 20:25:45

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
local age = 3600
local credentials = true

local function join(delimiter, list)
    if delimiter == nil or type(delimiter) ~= 'string' then
        delimiter = ' '
    end

    if #list == 0 then
        return ""
    end


    local s = list[1]

    for i = 2, #list do
        s = s .. delimiter .. list[i]
    end

    return s
end

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
    age = age
end

function _M.allow_credentials(credentials)
    credentials = credentials
end

function _M.run()
    local origin = ngx.req.get_headers()[Origin]
    if not origin then
        return
    end

    local matched = false
    for k, v in pairs(allow_hosts) do
        ngx.log(ngx.ERR, "host ", v, 'origin', origin)
        local from, to, err = ngx.re.find(origin, v, "jo")
        ngx.log(ngx.ERR, 'from', from)
        if from then
            matched = true
        end
    end

    if matched == false then
        return
    end

    ngx.header[AccessControlAllowOrigin] = origin
    ngx.header[AccessControlMaxAge] = age

    if #expose_headers >= 0 then
        ngx.header[AccessControlExposeHeaders] = join(',', expose_headers)
    end

    if #allow_headers >= 0 then
        ngx.header[AccessControlAllowHeaders] = join(',', allow_headers)
    end

    if #allow_methods >= 0 then
        ngx.header[AccessControlAllowMethods] = join(',', allow_methods)
    end

    if credentials == true then
        ngx.header[AccessControlAllowCredentials] = "true"
    else
        ngx.header[AccessControlAllowCredentials] = "false"
    end
end

return _M
