PATH := /opt/openresty/nginx/sbin:/usr/local/openresty/nginx/sbin:/usr/local/bin:$(PATH)

test:
	@WORKDIR=$(shell pwd) /usr/bin/prove

.PHONY: test
