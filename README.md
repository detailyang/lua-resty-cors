Name
====
lua-resty-cors

# lua-resty-cors
It's the implement of [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) on OpenResty and 
It backports the [nginx-http-cors](https://github.com/x-v8/ngx_http_cors_filter) to OpenResty

Table of Contents
-----------------
* [Name](#name)
* [Status](#status)
* [Usage](#usage)
* [API](#api)
* [Contributing](#contributing)
* [Author](#author)
* [License](#license)


Status
====
[![Build Status](https://travis-ci.org/detailyang/lua-resty-cors.svg?branch=master)](https://travis-ci.org/detailyang/lua-resty-cors)

Usage
====
It shoule be placed on the nginx output header phase. In OpenResty it should be header_filter_by_lua\*. The config shoule be like as the following:

````bash

http {
      header_filter_by_lua_block {
        local cors = require('lib.resty.cors');

        cors.allow_host([==[.*\.google\.com]==])
        cors.allow_host([==[.*\.facebook\.com]==])
        cors.expose_header('x-custom-field1')
        cors.expose_header('x-custom-field2')
        cors.allow_method('GET')
        cors.allow_method('POST')
        cors.allow_method('PUT')
        cors.allow_method('DELETE')
        cors.allow_header('x-custom-field1')
        cors.allow_header('x-custom-field2')
        cors.max_age(7200)
        cors.allow_credentials(false)
        
        cors.run()
    }
}
````

API
====

allow_host
---
`syntax: cors.allow_host(host)`

This will match the host from cors request then be added to the header Access-Control-Allow-Origin like as the following:

````bash
Request:
Origin: https://www.google.com

Response:
Access-Control-Allow-Origin: http://www.google.com
````

expose_header
---
`syntax: cors.expose_header(header)`

This will be added to the header Access-Control-Expose-Headers like as the following:

````bash
Request:
Origin: https://www.google.com

Response:
Access-Control-Expose-Headers: x-custom-field1,x-custom-field2
````

allow_method
---
`syntax: cors.allow_method(method)`

This will be added to the header Access-Control-Allow-Methods like as the following:

````bash
Request:
Origin: https://www.google.com

Response:
Access-Control-Allow-Methods:GET,POST,PUT
````

allow_header
---
`syntax: cors.allow_header(header)`

This will be added to the header Access-Control-Allow-Headers like as the following:

````bash
Request:
Origin: https://www.google.com

Response:
Access-Control-Allow-Headers:x-custom-field1,x-custom-field2
````

max_age
---
`syntax: cors.max_age(age)`

This will be added to the header Access-Control-Max-Age like as the following:

````bash
Request:
Origin: https://www.google.com

Response:
Access-Control-Max-Age: 7200
````

Allow-Credentials
---
`syntax: cors.allow_credentials(true or false)`

This will be added to the header Access-Control-Allow-Credentials like as the following:

````bash
Request:
Origin: https://www.google.com

Response:
Access-Control-Allow-Credentials: true
````

run
---
`syntax: cors.run()`

This is the entry for lua-resty-cors to run


Contributing
------------

To contribute to lua-resty-cors, clone this repo locally and commit your code on a separate branch.

PS: PR Welcome :rocket: :rocket: :rocket: :rocket:


Author
------

> GitHub [@detailyang](https://github.com/detailyang)

License
-------
lua-resty-cors is licensed under the [MIT] license.

[MIT]: https://github.com/detailyang/ybw/blob/master/licenses/MIT
