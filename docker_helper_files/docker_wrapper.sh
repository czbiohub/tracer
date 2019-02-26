#!/bin/bash

set -e
set -x

export IGDATA=/ncbi-igblast-1.7.0/bin

S3_FASTQ1_PATH=${3}
S3_FASTQ2_PATH=${4}
SAMPLE_ID=${5}
OUTPUT_BUCKET_PATH=${6}

aws s3 cp $S3_FASTQ1_PATH .
aws s3 cp $S3_FASTQ2_PATH .

gunzip -f *.fastq.gz

READ1=$(basename $S3_FASTQ1_PATH | sed 's/.gz//g')
READ2=$(basename $S3_FASTQ2_PATH | sed 's/.gz//g')

cp /tracer/docker_helper_files/docker_tracer.conf ~/.tracerrc

tracer assemble --ncores 4 --species Mmus $READ1 $READ2 $SAMPLE_ID $SAMPLE_ID

aws s3 sync $SAMPLE_ID $OUTPUT_BUCKET_PATH
