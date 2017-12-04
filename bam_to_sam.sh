#!/bin/bash

: '
Program:		bam_to_sam.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program converts a bam file to a sam file using samtools

How to run: 	bash bam_to_sam.sh
'

#for every bam file in this directory
for f in /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/*.bam
do
	#get the basename of the file
	file=$(basename "${f%%.bam}")
	#convert the bam file to a sam file using the samtools view option
	samtools view "${f}" > /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/SAM_for_blast/"${file}".sam 
done
