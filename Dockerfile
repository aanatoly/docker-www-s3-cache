FROM openresty/openresty:alpine


ENV API_GATEWAY_AWS_REF hmc/s3-authorization
ENV API_GATEWAY_HMAC_REF hmc/s3-authorization

RUN \
      addgroup -S nginx \
      && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
      && mkdir -p /usr/local/openresty/nginx/conf/conf.d/ /usr/local/src \
      && apk add --no-cache --virtual .build-deps \
             git \
             make \
      && git clone -b ${API_GATEWAY_AWS_REF} https://github.com/azavea/api-gateway-aws.git /usr/local/src/api-gateway-aws \
      && cd /usr/local/src/api-gateway-aws \
      && make -e PREFIX=usr/local/openresty install \
      && git clone -b ${API_GATEWAY_HMAC_REF} https://github.com/azavea/api-gateway-hmac.git /usr/local/src/api-gateway-hmac \
      && cd /usr/local/src/api-gateway-hmac \
      && make -e PREFIX=usr/local/openresty install \
      && apk del .build-deps \
      && rm -rf /usr/local/src

RUN apk add --update --no-cache \
    python \
    python-dev \
    py-pip \
    bash \
  && pip install --no-cache-dir envtpl \
  && rm -rf /var/cache/apk/*

# COPY usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
# COPY usr/local/openresty/nginx/conf/conf.d/default.conf.in /usr/local/openresty/nginx/conf/conf.d/default.conf.in
# COPY entrypoint.sh /entrypoint.sh
COPY rfs/ /

VOLUME /var/cache/nginx

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
