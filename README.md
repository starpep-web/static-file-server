# Service - Static File Server

This repository contains the code to build a nginx HTTP(s) server to serve the project's assets.

Make sure to check [assets](https://github.com/starpep-web/assets) to read how to acquire the assets for local development. This image is used by [env-development](https://github.com/starpep-web/env-development), so there's a chance you might need to have the assets on your machine to develop the other services.

## Requirements

In order to develop for this repository you need:

* [Docker](https://www.docker.com/products/docker-desktop/)

## Development

First, clone this repository:

```bash
git clone https://github.com/starpep-web/static-file-server
```

## Content

Head over to [assets](https://github.com/starpep-web/assets) to check how to acquire the assets.

* Data assets should be mounted as a volume in `/files`. These are the files found in [assets](https://github.com/starpep-web/assets).
* Temporary files should be mounted as a volume in `/tmp/files`. This should be a folder managed by [api-bio](https://github.com/starpep-web/api-bio) to serve exports through this server.

## Building

If you're developing this on your local machine, consider building the Docker image with the following command:

```bash
docker build -t local-starpep/static-file-server:latest .
```

You can create a new container to try it out with the following command:

```bash
docker run -it --rm -p 8080:8080 -v $PATH_TO_FILE_ASSETS:/files -v $PATH_TO_TEMP_FOLDER:/tmp/files local-starpep/static-file-server:latest
```

And done, the service should be reachable at `http://localhost:8080`.

## Production

Consider checking this [docker-compose.yml](https://github.com/starpep-web/env-production/blob/main/docker-compose.yml) for an example on how to run this image in production.
