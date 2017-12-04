#!/bin/bash

: '
Program:		mergeBam.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program merges two bam files into one

How to run: 	bash sorter.sh

'

#for every bam file in this directory
for f in /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/*.bam
do
	#get the basename of the file
	file=$(basename "${f}")
	#when the combined bam does not exist, continue
	if [ ! -f /media/imgorter/1TB_Seagate/barplot_data/combined_bam/"${file}" ]; then
	#call the samtools merge function for a bam file in one directory with the corresponding name of a bam in another directory
    samtools merge /media/imgorter/1TB_Seagate/barplot_data/combined_bam/"${file}" "${f}" /media/imgorter/1TB_Seagate/run_pathogens_from_report/bam_output/"${file}"
	fi
	
done	
	

