#!/bin/bash

"""
Program:		bam_to_sam.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program converts a bam file to a sam file using samtools

How to run: 	bash bam_to_sam.sh

"""

for f in /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/*.bam
do
	file=$(basename "${f%%.bam}")
	samtools view "${f}" > /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/SAM_for_blast/"${file}".sam 
done
