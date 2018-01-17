#!/bin/bash

: '
Program:		sorter.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program creates a sorted text file from a given file

How to run: 	bash sorter.sh

'

#for every file in the directory
for f in /media/imgorter/6CEC0BDEEC0BA186/imgorter/plot_data/dotplot/*.txt 
do
	#Get the basename of the file
	file=$(basename "${f%%.txt}")
	#call the bash sort command
	sort "${f}" -o /media/imgorter/6CEC0BDEEC0BA186/imgorter/plot_data/dotplot/sorted/"${file}".txt
done
