# Caddy build from source with plugins

This Dockerfile builds the caddy server from a specific tag from github and adds
the plugins listed in the `plugins.go` file. It usese my [caddy-builder](https://github.com/ulrichSchreiner/caddy-builder) for the compile step and my [caddy-runtime](https://github.com/ulrichSchreiner/caddy-runtime) as the runtime image.

Start the container this way (this needs a `Caddyfile` in your cwd):
~~~
docker run -it --rm \
  -v $PWD/Caddyfile:/etc/Caddyfile:ro \
  -v /path/to/persistent/volume:/home/caddy/.caddy \
  ulrichschreiner/caddy-http:latest --conf /etc/Caddyfile -agree -log stdout -port 80 -email you@your.domain
~~~

The server uses UID/GID 2002 to write files to `/home/caddy/.caddy` (letsencrypt certificates and keys). If you mount a local volume to this path make sure that this UID/GID has appropriate rights. Caddy will also run with this UID and not as root!
