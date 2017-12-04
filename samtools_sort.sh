#!/bin/bash

: '
Program:		samtools_sort.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program sorts a given bam or sam file using sam tools

How to run: 	bash samtools_sort.sh

'

#for every bam file in this directory
for f in /media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/*.bam
do
	#call the samtools sort command and use the input file as output
	samtools sort "${f}" -o "${f}"
done	
	
