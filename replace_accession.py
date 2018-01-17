#!/usr/bin/python3

"""
Program:	replace_accession.py
Version:	1.0
Author:		I.M. Gorter
Goal: 		Create a suitable file for the barplot from the output of the pileup 
Date: 		10-11-2017

"""

#imports
import glob
from os.path import basename


def remove_zero(f):
	"""
	This function removes the lines that have 0% coverage.
	When the fifth element is 0.0000, it means the coverage is 0%.
	"""
	#open the inputfile and read the lines
	openf = open(f, "r")
	lines = openf.readlines()

	openf.close()
	
	#open the inputfile as write
	openf = open(f, "w")
	for line in lines:
		#file is tab seperated, get all elements
		splitted = line.split("\t")
		#if the fifth element is 0.0000, coverage is 0%
		if splitted[4] == "0.0000":
			#dont write it back to the file
			pass
		else:
			#if the fifth element something else, write the line back
			openf.write(line)

	openf.close()


def get_Genomes():
	"""
	This function creates a dictionary that contains the accession number
	with the corresponding scientific name
	"""
	#multifasta that contains all organisms
	filenames = ['/media/imgorter/Extern/Pathogen_genomes/Multifasta/bacteria_pathogen_viruses.fa', '/media/imgorter/Extern/Pathogen_genomes/Multifasta/genomes.fasta', '/media/imgorter/Extern/Pathogen_genomes/Multifasta/genomes_without_pseudomonas_and_excel']

	#Create empty dictionary
	genomedict = {}

	for fname in filenames:
		print("working on genomedict " + fname)
		with open(fname) as AllGenomes:
			for line in AllGenomes:
				#if the line startswith >gi, get the organism name between the |
				if line.startswith(">gi"):
					genome = line.split(">")[1].split(",")[0]
					refname = genome.split("| ")[0]
					organism = genome.split("| ")[1]
					#add accessionnumber and name to dictionary
					genomedict[refname] = ' '.join(organism.split(" ")[:2])
					
				#If the line startswitch something else, get the scientific name after the second space till the end
				elif line.startswith(">JPKZ") or line.startswith(">MIEF") or line.startswith(">LL") or line.startswith(">AWXF") or line.startswith("EQ") or line.startswith(">NW_") or line.startswith(">LWMK") or line.startswith(">NZ_") or line.startswith(">NC_") or line.startswith(">KT"):
					genome = line.split(">")[1].split(",")[0]
					refname = genome.split(" ")[0]
					organismName = genome.split(" ")[1:]
					organism = ' '.join(organismName)
					#add accessionnumber and name to dictionary
					genomedict[refname] = ' '.join(organism.split(" ")[:2])
		
	
	return genomedict

def replace_accession_with_name(f, genomedict):
	"""
	This function replaces the accessionnumber with the scientific name
	Uses the dictionary with the accessionumber and name from the get_Genomes() function
	"""
	print("now working on file: " + f)
	#create empty list
	accession_nrs = []
	#get the basename of the file
	bn = basename(f)
	#open the file and read the lines
	openf = open(f, "r")
	lines = openf.readlines()[1:]
	openf.close()
	#open the file writeable
	newopenf = open(f, "w")
	for line in lines:
		#file is tab separated
		splitted = line.split("\t")[0]
		if splitted not in genomedict:
			pass
		else:
			#replace the accessionnumber with the scientific name that has the corresponding accessionnumber in the genomedict
			line = str(line).replace(str(splitted), str(genomedict[splitted]))
			#write to file
			newopenf.write(line)
			
def main():
	gd = get_Genomes()
	for f in glob.glob("/media/imgorter/6CEC0BDEEC0BA186/imgorter/barplot_data/Biopsy/pileup/*.txt"):
		remove_zero(f)
		replace_accession_with_name(f, gd)
	
if __name__ == "__main__":
	main()
