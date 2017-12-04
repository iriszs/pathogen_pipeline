#!/bin/bash

: '
Program:	pileuprun.sh
Version: 	1.0
Author:		I.M. Gorter
Goal:		This program calls pileup.sh for every file in a directory

How to run:	bash pileuprun.sh

'

for f in /media/imgorter/1TB_Seagate/barplot_data/combined_bam/*.bam
do
	#get the basename of the file
	file=$(basename "${f%%.txt}")
	#call pileup.sh for every inputfile and create a outputfile using the basenames
	/home/imgorter/lib/BBMap_37.66/bbmap/pileup.sh in="${f}" out=test_bam.txt out=/media/imgorter/1TB_Seagate/barplot_data/pileup/"${file}".txt 32bit=T -Xmx10g
	
done	
