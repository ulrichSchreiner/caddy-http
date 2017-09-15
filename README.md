# Caddy build from source with plugins

This Dockerfile builds the caddy server from a specific tag from github and adds
the plugins listed in the `plugins.go` file. It usese my [caddy-builder](https://github.com/ulrichSchreiner/caddy-builder) for the compile step.

Start the container this way (this needs a `Caddyfile` in your cwd):
~~~
docker run -it --rm -v $PWD/Caddyfile:/etc/Caddyfile:ro ulrichschreiner/caddy-http:latest --conf /etc/Caddyfile
~~~
