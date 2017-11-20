#!/usr/bin/python3

"""
Program:	get_sequences.py
Version:	1.0
Author:		I.M. Gorter
Goal:		Get the left sequences out of a fastq file and create a unique reference for it
Date: 		10-11-2017

"""


#imports
import glob
from os.path import basename


def get_Sequences(f):
	"""
	This function retrieves the sequences from a bam file and writes it to a new file with a reference number
	"""
	
	#get the basename from the file
	bn = basename(f)
	
	with open('/media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/fastq_from_bam/paired/' + bn, 'r') as infile, open('/media/imgorter/1TB_Seagate/for_blast/' + bn, 'w') as outfile:
		copy = False
		for line in infile:
			#Every line that contains a sequence starts with @HWI
			if line.startswith("@HWI"):
				copy = True
				#Replace this with >gi to create a unique reference
				giNumber = line.replace("@HWI", ">gi")
			#the + mark means the end of the sequence	
			elif line.strip() == "+":
				copy = False
			#write lines from @HWI till + to a new file
			elif copy:
				outfile.write(giNumber + line + "\n")			


def main():
	#for every fastq in this directory
	for f in glob.glob('/media/imgorter/1TB_Seagate/run_new_pathogens/bam_output/bam_mapped/fastq_from_bam/paired/*.fastq'):
		if "_r1" in f:
			get_Sequences(f)	
	
if __name__ == "__main__":
	main()	
