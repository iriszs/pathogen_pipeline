#!/usr/bin/python3

"""
Program: 	count_basepair_per_pathogen.py
Version: 	1.0
Author:		I.M. Gorter
Goal:		This program counts for every pathogen the basepairs that have been aligned

"""

#imports
import glob
from os.path import basename


def basepair_per_pathogen(f):
	"""
	This function determines how many basepairs have been aligned per pathogen
	"""
	#basename of the file
	bn = basename(f)
	#creation of empty dictionary
	bpdict = {}
	
	openf = open(f, "r")
	
	for line in openf:
		#the pathogen is the first element
		pathogen = line.split("\t")[0]
		#the aligned basepairs is the sixt element
		basepair = int(line.split("\t")[5])
		#if the pathogen is not yet in the dictionary, add it with the basepairs
		if pathogen not in bpdict:
			bpdict[pathogen] = basepair
		#if the pathogen is in the dictionary, add the basepairs to the already existing basepairs	
		else:
			bpdict[pathogen] += basepair
			
	openf.close()		
	
	#open the outputfile
	newf = open("/media/imgorter/6CEC0BDEEC0BA186/imgorter/barplot_data/Biopsy/pileup/bp_per_pathogen/" + bn, "w")
	
	#for every pathogen-basepair combination, write to file
	for bp in bpdict:
		newf.write(bp + "\t" + str(bpdict[bp]) + "\n")
		
	
	
	
	
def main():
	for f in glob.glob("/media/imgorter/6CEC0BDEEC0BA186/imgorter/barplot_data/Biopsy/pileup/*.txt"):
		basepair_per_pathogen(f)


if __name__ == "__main__":
	main()
