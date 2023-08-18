# Static File Server Docker Image

This repository contains a Dockerfile to build the static file server to serve assets through http(s).

## Requirements

In order to make use of this Docker image, [Docker](https://www.docker.com/) should be installed in your machine.

## Building

To build this image, run the following command from the folder of this repository.

```text
docker build -t test/static-file-server .
```

> TODO: Replace `test/static-file-server` with the name of the image to use.

## Testing

You can start the server locally with:

```text
docker run -it --rm -p 8080:8080 -v $PATH_TO_FILE_ASSETS:/files -v $PATH_TO_TEMP_FOLDER:/tmp/files test/static-file-server
```

> TODO: Replace `test/static-file-server` with the name of the image to use.

## Content

Content is no longer provided inside the Docker image. Instead, a git repo with the content can be found in the image's registry. This folder should be used as a volume when creating the container
to serve the proper data.

* Data assets should be mounted as a volume in `/files`.
* Temporary files should be mounted as a volume in `/tmp/files`.
