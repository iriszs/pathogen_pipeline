#!/bin/bash

: '
Program:		count_basepair.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program writes the number of basepairs the mapped bam file contains to eventually calculate the unknown basepairs

How to run: 	bash count_basepair.sh

'

#for every bam in this directory
for f in /media/imgorter/1TB_Seagate/barplot_data/combined_bam/*.bam
do
	#get the basename of the file
	file=$(basename "${f}")
	#get the number of basepairs using the samtools view option with the parameter -c
	samtools view "${f}" -c -o /media/imgorter/1TB_Seagate/barplot_data/pileup/combined/total_bp/"${file}"
	
done
