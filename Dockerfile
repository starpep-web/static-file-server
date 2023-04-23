FROM alpine:3.17 AS build

WORKDIR /tmp

#---- START UNZIP COMPRESSED ----#

# Peptide PDBs
COPY ./compressed/1_3D_StarPepFasta2PDB_ESMfold.zip ./
RUN unzip 1_3D_StarPepFasta2PDB_ESMfold.zip && rm 1_3D_StarPepFasta2PDB_ESMfold.zip

# Peptide FASTAs
COPY ./compressed/StarPepFASTA.zip ./
RUN unzip StarPepFASTA.zip && rm StarPepFASTA.zip

# Peptide Metadata CSVs
COPY ./compressed/StarPep-Metadata-CSV.zip ./
RUN unzip StarPep-Metadata-CSV.zip && rm StarPep-Metadata-CSV.zip

# FASTA by Database
COPY ./compressed/StarPepFASTA-Databases.zip ./
RUN unzip StarPepFASTA-Databases.zip && rm StarPepFASTA-Databases.zip

#---- END UNZIP COMPRESSED ----#

FROM nginx:stable-alpine

RUN mkdir /etc/nginx/logs && touch /etc/nginx/logs/access.log

WORKDIR /files

#---- START FILES COPY ----#

# Peptides - PDBs
COPY --from=build /tmp/1_3D_StarPepFasta2PDB_ESMfold /files/peptides/pdb

# Peptides - FASTAs
COPY --from=build /tmp/StarPepFASTA /files/peptides/fasta

# Peptides - CSVs
COPY --from=build /tmp/StarPep-Metadata-CSV /files/peptides/csv/metadata

# DB ZIP(s)
COPY ./compressed/db /files/db

# Full Files
COPY ./compressed/full /files/full

# FASTA by Database
COPY --from=build /tmp/fasta-by-db /files/fasta-by-db

# ZIPPED ARCHIVES
COPY ./compressed/1_3D_StarPepFasta2PDB_ESMfold.zip /files/zip/StarPepPDB.zip
COPY ./compressed/StarPepFASTA-Databases.zip /files/zip/StarPepFASTA-Databases.zip

#---- END FILES COPY ----#

COPY ./config/ /etc/nginx/config/
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
