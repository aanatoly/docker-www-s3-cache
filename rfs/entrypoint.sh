#!/bin/bash


set_default()
{
    if [ -z "${!1}" ]; then
        export $1=$2
    fi
    echo "set default $1=${!1}"
}

set_default NGINX_CACHE_SIZE 20g
set_default NGINX_EXPIRE_TOUT 20d

TPL=/usr/local/openresty/nginx/conf/conf.d/default.conf
envtpl < $TPL.in > $TPL

exec /usr/local/openresty/bin/openresty -g "daemon off;"
