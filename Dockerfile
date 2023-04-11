FROM alpine:3.17 AS build

WORKDIR /tmp

COPY ./compressed/1_3D_StarPepFasta2PDB_ESMfold.zip ./
RUN unzip 1_3D_StarPepFasta2PDB_ESMfold.zip && rm 1_3D_StarPepFasta2PDB_ESMfold.zip

FROM nginx:stable-alpine

RUN mkdir /etc/nginx/logs && touch /etc/nginx/logs/access.log

WORKDIR /files

COPY --from=build /tmp/1_3D_StarPepFasta2PDB_ESMfold /files/pdb

COPY ./config/ /etc/nginx/config/
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080