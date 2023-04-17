FROM alpine:3.17 AS build

WORKDIR /tmp

#---- START UNZIP COMPRESSED ----#

# PDBs
COPY ./compressed/1_3D_StarPepFasta2PDB_ESMfold.zip ./
RUN unzip 1_3D_StarPepFasta2PDB_ESMfold.zip && rm 1_3D_StarPepFasta2PDB_ESMfold.zip

# FASTAs
COPY ./compressed/StarPepFASTA.zip ./
RUN unzip StarPepFASTA.zip && rm StarPepFASTA.zip

# Metadata CSVs
COPY ./compressed/StarPep-Metadata-CSV.zip ./
RUN unzip StarPep-Metadata-CSV.zip && rm StarPep-Metadata-CSV.zip

#---- END UNZIP COMPRESSED ----#

FROM nginx:stable-alpine

RUN mkdir /etc/nginx/logs && touch /etc/nginx/logs/access.log

WORKDIR /files

#---- START FILES COPY ----#

# PDBs
COPY --from=build /tmp/1_3D_StarPepFasta2PDB_ESMfold /files/pdb

# FASTAs
COPY --from=build /tmp/StarPepFASTA /files/fasta

# CSVs
COPY --from=build /tmp/StarPep-Metadata-CSV /files/csv/metadata

# DB ZIP(s)
COPY ./compressed/db /files/db

# Full Files
COPY ./compressed/full /files/full

# ZIPPED ARCHIVES
COPY ./compressed/1_3D_StarPepFasta2PDB_ESMfold.zip /files/zip/StarPepPDB.zip
COPY ./compressed/StarPepFASTA.zip /files/zip/StarPepFASTA.zip

#---- END FILES COPY ----#

COPY ./config/ /etc/nginx/config/
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
