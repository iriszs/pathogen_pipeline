#!/bin/bash

"""
Program:		create_paired_end.sh
Version:		1.0
Author:		 	I.M. Gorter
Goal: 			This program creates paired end reads from one fastq file

How to run: 	bash create_paired_end.sh

"""

for f in /media/imgorter/1TB_Seagate/fastq/*.fastq
do
	cat "$f" | grep '^@.*/1$' -A 3 --no-group-separator > /media/imgorter/1TB_Seagate/fastq/paired"${f%%.*}"_r1.fastq && grep '^@.*/2$' -A 3 --no-group-separator > /media/imgorter/1TB_Seagate/fastq/paired"${f%%.*}"_r2.fastq
done
