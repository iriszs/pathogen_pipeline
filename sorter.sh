#!/bin/bash

: '
Program:		sorter.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program creates a sorted text file from a given file

How to run: 	bash sorter.sh

'

#for every file in the directory
for f in /media/imgorter/1TB_Seagate/run_pathogens_from_report/results/scientific_names/single_names/*.txt 
do
	#Get the basename of the file
	file=$(basename "${f%%.txt}")
	#call the bash sort command
	sort "${f}" -o /media/imgorter/1TB_Seagate/run_pathogens_from_report/results/scientific_names/single_names/sorted/"${file}".txt
done
