FROM alpine:3.17 AS build

WORKDIR /tmp

#---- START UNZIP COMPRESSED ----#

# PDBs
COPY ./compressed/1_3D_StarPepFasta2PDB_ESMfold.zip ./
RUN unzip 1_3D_StarPepFasta2PDB_ESMfold.zip && rm 1_3D_StarPepFasta2PDB_ESMfold.zip

# FASTAs
COPY ./compressed/StarPepFASTA.zip ./
RUN unzip StarPepFASTA.zip && rm StarPepFASTA.zip

#---- END UNZIP COMPRESSED ----#

FROM nginx:stable-alpine

RUN mkdir /etc/nginx/logs && touch /etc/nginx/logs/access.log

WORKDIR /files

#---- START FILES COPY ----#

# PDBs
COPY --from=build /tmp/1_3D_StarPepFasta2PDB_ESMfold /files/pdb

# FASTAs
COPY --from=build /tmp/StarPepFASTA /files/fasta

# DB ZIP
COPY ./compressed/db /files/db

# ZIPPED ARCHIVES
COPY ./compressed/1_3D_StarPepFasta2PDB_ESMfold.zip /files/zip/StarPepPDB.zip
COPY ./compressed/StarPepFASTA.zip /files/zip/StarPepFASTA.zip

#---- END FILES COPY ----#

COPY ./config/ /etc/nginx/config/
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
