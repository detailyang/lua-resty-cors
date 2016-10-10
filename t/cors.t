use Test::Nginx::Socket 'no_plan';

my $workdir = $ENV{WORKDIR};

our $http_config = <<"_EOC_";
  lua_package_path '$workdir/?.lua;;';
_EOC_

repeat_each(1);
no_shuffle();
run_tests();

__DATA__

=== Test1: test one allow_host google.com
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.google\.com]==])

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: http://www.google.com

--- response_headers
Access-Control-Allow-Origin: http://www.google.com


=== Test2: test one allow_host google.com
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.google\.com]==])

    cors.run()
  }
}

--- request
GET /1

--- more_headers

--- response_headers
Access-Control-Allow-Origin:



=== Test3: test multi allow_host google.com
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.google\.com]==])
    cors.allow_host([==[.*\.facebook\.com]==])

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com



=== Test4: test one expose_header
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.expose_header('x-custom-field1')

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Expose-Headers: x-custom-field1



=== Test5: test multi expose_header
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.expose_header('x-custom-field1')
    cors.expose_header('x-custom-field2')

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Expose-Headers: x-custom-field1,x-custom-field2



=== Test6: test one allow_method
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.allow_method('GET')

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Allow-Methods: GET



=== Test7: test multi expose_header
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.allow_method('GET')
    cors.allow_method('POST')

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Allow-Methods: GET,POST



=== Test8: test one allow_method
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.allow_header('x-custom-field1')

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Allow-Headers: x-custom-field1



=== Test9: test multi expose_header
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.allow_header('x-custom-field1')
    cors.allow_header('x-custom-field2')

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Allow-Headers: x-custom-field1,x-custom-field2



=== Test10: test max_age
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.max_age(7200)

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Max-Age: 7200



=== Test11: test allow_credentials
--- http_config eval: $::http_config

--- config
location = /1 {
  content_by_lua_block {
    ngx.say("hello world")
  }

  header_filter_by_lua_block {
    local cors = require('lib.resty.cors');

    cors.allow_host([==[.*\.facebook\.com]==])
    cors.allow_credentials(false)

    cors.run()
  }
}

--- request
GET /1

--- more_headers
Origin: https://www.facebook.com

--- response_headers
Access-Control-Allow-Origin: https://www.facebook.com
Access-Control-Allow-Credentials: false
