# Static File Server Docker Image

This repository contains a Dockerfile to build the static file server to serve assets through http(s).

This is an nginx server with the assets already included in the image.

## Requirements

In order to make use of this Docker image, [Docker](https://www.docker.com/) should be installed in your machine.

## Submodules

The `compressed` folder is a git submodule of the [repo](https://code.moonstar-x.dev/webpep/static-files) that contains the compressed assets.

If you need to download this you will need to login with your credentials from the [registry](https://code.moonstar-x.dev/webpep). Then you can run:

```text
git submodule update --init
```

## Building

To build this image, run the following command from the folder of this repository.

```text
docker build -t test/static-file-server .
```

> TODO: Replace `test/static-file-server` with the name of the image to use.

If you have added or edited files in the `compressed` folder or if you're building the image for production, it is recommended to include the `--no-cache` flag in the build command since Docker cannot accurately track changes in `.zip` files.

## Testing

You can start the server locally with:

```text
docker run -it --rm -p 8080:8080 test/static-file-server
```

> TODO: Replace `test/static-file-server` with the name of the image to use.

## Content

The `compressed` folder contains the assets to serve compressed. The `Dockerfile` should unzip these archives in the build stage and copy them into the `/files` folder in the main stage.

For example, let's say we have a `my-files.zip` file that needs to be served in the `/cool-files` path. You should add the following entries into the `Dockerfile`'s build stage:

```docker
COPY ./compressed/my-files.zip ./
RUN unzip my-files.zip && rm my-files.zip
```

And in the main stage:

```docker
COPY --from=build /tmp/my-files /files/cool-files
```

Make sure to add this line above the `COPY config...` lines to avoid having to copy these files whenever a change is made to the config files.
