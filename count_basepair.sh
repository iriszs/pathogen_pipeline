#!/bin/bash

"""
Program:		count_basepair.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program writes the number of basepairs the mapped bam file contains to eventually calculate the unknown basepairs

How to run: 	bash count_basepair.sh

"""

for f in /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/*.bam
do
	file=$(basename "${f}")
	samtools view "${f}" -c -o /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/counts/"${file}"
	
done	
