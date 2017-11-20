#!/bin/bash

"""
Program:		sorter.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program creates a sorted text file from a given file

How to run: 	bash sorter.sh

"""

for f in /media/imgorter/1TB_Seagate/run_new_pathogens/results/try_again/single/*.txt 
do
	#Get the basename of the file
	file=$(basename "${f%%.txt}")
	#call the bash sort command
	sort "${f}" -o /media/imgorter/1TB_Seagate/run_new_pathogens/results/try_again/single/Sorted/"${file}".txt
done
