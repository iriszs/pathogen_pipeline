#!/usr/bin/python3

#imports
import collections
import subprocess
import os
import glob
from os.path import basename

#THESE VARIABLES NEED TO BE ALTERED BY THE USER

#Name for the run
run_name = "test_run1"
#directory where directories with results can be placed
basedirectory = "/media/imgorter/6CEC0BDEEC0BA186/imgorter/"
#directory where the inputfiles are (must be in fastq)
inputdirectory = "/media/imgorter/6CEC0BDEEC0BA186/imgorter/TEST_INPUT/"
#place where the fasta of the human genome is
human_genome = "/home/imgorter/Documents/Human_Genome/GRCh38_latest_genomic.fna"
#place where the fasta of the pathogen genomes is
pathogen_fasta = "/media/imgorter/BD_1T/imgorter/bacteria_pathogen_viruses.fa"

#these should not be altered!
#are used to create directories and refer to paths in the commands
inputfiles = inputdirectory + "*"
directory = basedirectory + "/" + run_name + "/"
index_directory = directory + "/index/"
unmapped = directory + "/Unmapped/"
bam = directory + "/bam_output/"
mapped_bam = bam + "/bam_mapped/"
results = directory + "/results/"
accession = results + "/accession_numbers/"
science_names = results + "/scientific_names/"
sam = directory + "/sam_output/"
tmp_directory = directory + "/tmp_directory/"
log_directory = directory + "/log/"
human_index = index_directory + "human"
pathogen_index = index_directory + "pathogen"


def makeDirectories():
	os.makedirs(directory)
	os.makedirs(unmapped)				
	os.makedirs(bam)
	os.makedirs(mapped_bam)
	os.makedirs(results)				
	os.makedirs(accession)	
	os.makedirs(science_names)
	os.makedirs(sam)


def createBowtie2Index():
	subprocess.run(["bowtie2-build", human_genome, human_index]) 
	subprocess.run(["bowtie2-build", pathogen_fasta, pathogen_index])


def runBowtie2ToHumanGenome(f):
	logfile = log_directory + f + ".txt"
	basefilename = f.split("_r1")[-1]
 	subprocess.run(["bowtie2", "-x", human_index, "-1", f, "-2", basefilename + "_r2.fastq", "--un-conc", unmapped + basefilename + ".fastq" "-S", tmp_directory + basefilename + ".sam", "--no-unal", "--no-hd", "-no-sq"], stdout=logfile)	
		

def main():
	makeDirectories()
	createBowtie2Index
	#for every SET of files:
		runBowtie2ToHumanGenome(f)


if __name__ == "__main__":
	main()
