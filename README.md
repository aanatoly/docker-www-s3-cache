# docker-www-s3-cache
`nginx` forward proxy, that redirects **magic** urls http://www.s3 to a private AWS S3 bucket.

## Usage
Start the cache

```bash
export AWS_ACCESS_KEY_ID=TBD
export AWS_SECRET_ACCESS_KEY=TBD
docker run -d \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e NGINX_EXPIRE_TOUT=20d \
  -e NGINX_CACHE_SIZE=30g \
  -v /var/cache/s3-cache:/var/cache/nginx \
  -p 8080:80 \
  aanatoly/www-s3-cache
```
The NGINX_* variables are optional, the image will use above values by default.

Configure http proxy
```bash
export http_proxy=http://localhost:8080
```
Now we can fetch some files
```bash
curl http://www.s3/my-bucket/path/image.jpg  # goes to s3://my-bucket/path/image.jpg
curl http://gitlab.com/path/image.jpg        # goes to http://gitlab.com/path/image.jpg
```

## Developmemnt
Run `make up_MNPR`
