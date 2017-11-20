#!/usr/bin/python3


"""
Program: 	getName.py
Version: 	1.0
Author:		I.M. Gorter
Goal:		Give the scientific names of accession numbers in a file

"""

#imports
import collections
import glob
from os.path import basename


def get_Genomes():
	"""
	This function creates a dictionary that contains the accession number
	with the corresponding scientific name
	"""
	AllGenomes = open("/media/imgorter/Extern/Excel_list/genomes.fasta")
	
	#multifasta that contains all organisms
	genomedict = {}

	for line in AllGenomes:
		#if the line startswith >gi, get the organism name between the |
		if line.startswith(">gi"):
			genome = line.split(">")[1].split(",")[0]
			refname = genome.split("| ")[0]
			organism = genome.split("| ")[1]
			#add accessionnumber and name to dictionary
			genomedict[refname] = organism
	
		#If the line startswitch something else, get the scientific name after the second space till the end
		elif line.startswith(">JPKZ") or line.startswith(">MIEF") or line.startswith(">LL") or line.startswith(">AWXF") or line.startswith("EQ") or line.startswith(">NW_") or line.startswith(">LWMK") or line.startswith(">NZ_") or line.startswith(">NC_") or line.startswith(">KT"):
			genome = line.split(">")[1].split(",")[0]
			refname = genome.split(" ")[0]
			organismName = genome.split(" ")[1:]
			organism = ' '.join(organismName)
			genomedict[refname] = organism
			
	return genomedict		


def accessionToName(f, genomedict):
	"""
	This function writes the pathogens to a file. It also creates a file with single names,
	because some pathogens have multiple hits due the presence of multiple scaffolds/assembly reads.
	"""
	#create empty list for the accession numbers
	accession_nrs = []
	#the basename of the given file
	bn = basename(f)


	for line in open(f):
		#the accession number is the first element of a tab splitted line
		accession_nrs.append(line.split("\t")[0])

	pathogenNames = []
	outputfile = "/media/imgorter/1TB_Seagate/run_new_pathogens/results/try_again/" + bn
	openoutput = open(outputfile, "w")
	
	#for each accession number
	for number in accession_nrs:
		#if the number is in the genomedict, append it to the pathogenslist
		if number in genomedict:
			pathogenNames.append(genomedict[number])
	
	#for every pathogen in the pathogenNames, write to file
	for i in pathogenNames:
		openoutput.write(i + "\n")

	openoutput.close()
	
	outputfile = "/media/imgorter/1TB_Seagate/run_new_pathogens/results/try_again/" + bn
	outfile = open(outputfile, "r")
	finalpathogenfile = "/media/imgorter/1TB_Seagate/run_new_pathogens/results/try_again/single/" + "final_" +  bn 
	openfinalfile = open(finalpathogenfile, "w")

	pathogens = []
	
	#for every line in the previous made file
	for line in outfile:
		newline = line.split(" ")[:2]
		#if the newline does not contain a enter
		if not "\n" in newline:
			#if the pathogen is already present in the pathogenlist, don't write it again
			if newline in pathogens:
				pass
			#if the pathogen is not present in the pathogenlist, append it to the list	
			else:
				pathogens.append(newline)

	#for every pathogen in the list, write to file
	for pathogen in pathogens:		
		openfinalfile.write(' '.join(pathogen) + "\n")
	
	openfinalfile.close()	

def main():
	print("start")
	gd = get_Genomes()
	for f in glob.glob("/media/imgorter/1TB_Seagate/run_new_pathogens/results/accession_numbers/*.txt"):
		print("now working on this file: ", f)
		accessionToName(f, gd)
	
	
	

if __name__ == "__main__":
	main()
