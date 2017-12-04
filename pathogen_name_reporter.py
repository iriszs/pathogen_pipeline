#!/usr/bin/env python3

"""
Program: 	pathogen_name_reporter.py
Version: 	1.0
Author:		I.M. Gorter
Goal:		Get all the names of pathogens in a multifasta file and write to file

"""


def get_Genomes(f):
	"""
	This function creates a dictionary that contains the accession number
	with the corresponding scientific name
	"""
	#multifasta that contains all organisms
	AllGenomes = open(f)
	#outfile = open("/media/imgorter/Extern/pathogens1.txt", "w")
	#outfile = open("/media/imgorter/Extern/pathogens2.txt", "w")
	outfile = open("/media/imgorter/Extern/pathogens3.txt", "w")

	#Create empty dictionary
	genomedict = {}
	pathogens = []

	
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
			genomedict[refname] = ' '.join(organism.split(" "))
			
	#for every pathogenname		
	for pathogenname in genomedict.values():
		splitted = pathogenname.split(" ")
		if "strain" in pathogenname or "scaffold" in pathogenname or "plasmid" in pathogenname or "isolate" in pathogenname or "chromosome" in pathogenname or "segment" in pathogenname or "genome" in pathogenname:
			newsplit = splitted[:2]
			if newsplit not in pathogens:
				pathogens.append(newsplit)
				outfile.write(' '.join(newsplit) + "\n")
		else: 
			outfile.write(' '.join(splitted) + "\n")


def main():
	#f = '/media/imgorter/Extern/NEW_pathogens/new_pathogens.fasta' = 2
	#f = '/media/imgorter/Extern/Excel_list/genomes.fasta' = 1
	f = '/media/imgorter/BD_1T/imgorter/bacteria_pathogen_viruses.fa'
	get_Genomes(f)



if __name__ == "__main__":
	main()





		
