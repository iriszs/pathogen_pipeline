This repository is used for all scripts that have been used during the internship of Iris Gorter at the UMCG neuroscience department.

This repository contains several single bash and python scripts used for data manipulation/
It also contains R scripts for visualizations. 

Instructions for the pathogen pipeline:

PATHOGEN PIPELINE

searches for pathogenic sequences in paired end fastq files

Required to run:
python3
Bowtie2
samtools
bedtools

How to run:
download pipeline.py
Change the 5 variables at the beginning of the file.
Make sure the input fastq are paired end reads that look like this: sample1_r1.fastq sample2_r2.fastq

run: python3 pipeline.py


