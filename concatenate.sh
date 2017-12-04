#!/bin/bash

: '
Program:	concatenate.sh
Version: 	1.0
Author:		I.M. Gorter
Goal:		concatenates two text files

How to run:	bash concatenate.sh

'

for f in /media/imgorter/1TB_Seagate/barplot_data/pileup/with_genome_fasta/bp_per_pathogen/*.txt
do
	#get the basename of the file
	file=$(basename "${f%%.txt}")
	#concatenate two files with the same name together
	cat "${f}" /media/imgorter/1TB_Seagate/barplot_data/pileup/with_new_fasta/bp_per_pathogen/"${file}".txt > /media/imgorter/1TB_Seagate/barplot_data/pileup/combined/bp_per_pathogen/"${file}".txt
	
done	
