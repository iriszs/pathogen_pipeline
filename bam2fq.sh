#!/bin/bash

"""
Program:		bam2fq.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program sorts a bam file and converts it to a fastq file

How to run: 	bash bam2fq.sh

"""


for file in /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/*.bam
do
	fname=$(basename "${file%%.bam}")
	samtools sort -n "${file}" -o /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/fastq_from_bam/"${fname}".bam
done

for f in /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/fastq_from_bam/*.bam
do
	name=$(basename "${f%%.bam}")
	bamToFastq -i "${f}" -fq /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/fastq_from_bam/paired/"${name}"_r1.fastq -fq2 /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/fastq_from_bam/paired/"${name}"_r2.fastq
done




