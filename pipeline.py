#!/usr/bin/python3

#imports
import collections
import subprocess
import os
import glob
from os.path import basename
import os.path

#THESE VARIABLES NEED TO BE ALTERED BY THE USER

#Name for the run
run_name = "run_pathogens_from_report"
#directory where directories with results can be placed
basedirectory = "/media/imgorter/1TB_Seagate/"
#directory where the inputfiles are (must be in fastq)
inputdirectory = "/media/imgorter/6CEC0BDEEC0BA186/imgorter/Unmapped_data/"
#place where the fasta of the human genome is
human_genome = "/home/imgorter/Documents/Human_Genome/GRCh38_latest_genomic.fna"
#place where the multifasta of the pathogen genomes is
pathogen_fasta = "/media/imgorter/Extern/NEW_pathogens/new_pathogens.fasta"

#these should not be altered!
#are used to create directories and refer to paths in the commands
inputfiles = inputdirectory + "*.fastq"
directory = basedirectory + run_name
index_directory = directory + "/index/"
unmapped = directory + "/Unmapped/"
unmappedfiles = unmapped + "*.fastq"
bam = directory + "/bam_output/"
mapped_bam = bam + "/bam_mapped/"
results = directory + "/results/"
accession = results + "/accession_numbers/"
science_names = results + "/scientific_names/"
single_names = science_names + "/single_names/"
sam = directory + "/sam_output/"
tmp_directory = directory + "/tmp_directory/"
log_directory = directory + "/log/"
human_index = index_directory + "human"
#human_index = "/home/imgorter/Documents/Human_Genome/Bowtie2_index/human"
pathogen_index = index_directory + "pathogen"
#pathogen_index = "/media/imgorter/Extern/Indexen/new_pathogens_index"

#make directories
def makeDirectories():
	print("*** Making directories ***")
	os.makedirs(directory)
	os.makedirs(index_directory)
	os.makedirs(unmapped)
	os.makedirs(bam)
	os.makedirs(mapped_bam)
	os.makedirs(results)
	os.makedirs(accession)
	os.makedirs(science_names)
	os.makedirs(single_names)
	os.makedirs(sam)
	os.makedirs(tmp_directory)
	os.makedirs(log_directory)

#command to make bowtie2 indexes for the human genome and the pathogen fasta
def createBowtie2Index():
	print("*** Creating Bowtie2 index ***")
	subprocess.run(["bowtie2-build", human_genome, human_index])
	subprocess.run(["bowtie2-build", pathogen_fasta, pathogen_index])

#command to run Bowtie2 to filter out the human genome
def runBowtie2ToHumanGenome(f):
	print("Running Bowtie2 with file " + f + " against the human genome")
	filename = basename(f)
	basefilename = filename.split("_r1")
	logfile = log_directory + basefilename[0] + "_human_run.log"
	openlog = open(logfile, "w")
	subprocess.run(["bowtie2", "-x", human_index, "-1", f, "-2", f.split("_r1")[0] + "_r2.fastq", "--un-conc", unmapped + basefilename[0] + ".fastq", "-S", tmp_directory + basefilename[0] + ".sam", "--no-unal", "--no-hd", "--no-sq", "-p", "32"], stderr = openlog)

#command to run Bowtie2 against the pathogens
def runBowtie2ToPathogens(f):
	print("Running Bowtie2 with file " + f + " against the pathogens")
	filename = basename(f)
	basefilename = filename.split("_1")
	logfile = log_directory + basefilename[0] + "_pathogen_run.txt"
	if os.path.isfile(sam + basefilename[0] + ".sam"):
		print("this one has been executed already, skipping...") 
	else:
		openlog = open(logfile, "w")
		subprocess.run(["bowtie2", "-x", pathogen_index, "-1", f, "-2", f.split("_1")[0] + "_2.fastq", "-S", sam + basefilename[0] + ".sam", "-p", "26"], stderr = openlog)
	

#command to convert the sam file to bam file
def samToBam(f):
	basefilename = basename(f)
	base = os.path.splitext(basefilename)[0]
	print(base)
	if os.path.isfile(bam + base + ".bam"):
		print("this one has been executed already, skipping...") 
	else:
		print("Converting " + f + " to bam")
		subprocess.run(["samtools", "view", "-b", "-S", "-o", bam + base + ".bam", f])

#command to remove the failed to align parts out of the bam file (flag=4)
def removeFailedToAlign(f):
	print("Removing failed to align reads from this file: " + f)
	basefilename = basename(f)
	base = os.path.splitext(basefilename)[0]
	outfile = mapped_bam + base + "mapped.bam"
	openoutfile = open(outfile, "w")
	subprocess.run(["samtools", "view", "-b", "-F", "4", f], stdout = openoutfile)

#get the accessionnumbers from the bam file
def getAccessionNumbers(f):
	print("Retrieving accession numbers from this file: " + f)
	basefilename = basename(f)
	base = os.path.splitext(basefilename)[0]
	outfile = accession + base + ".txt"
	openoutfile = open(outfile, "w")
	subprocess.run(["bedtools", "bamtobed", "-i", f], stdout = openoutfile)

#get all genome accession numbers and save them in a dictionary
def get_Genomes():
	print("*** Creating genome dictionary ***")
	AllGenomes = open(pathogen_fasta)

	genomedict = {}

	for line in AllGenomes:
		if line.startswith(">gi"):
			print("begint met gi")
			genome = line.split(">")[1].split(",")[0]
			refname = genome.split("| ")[0]
			organism = genome.split("| ")[1]
			genomedict[refname] = organism
	
		elif line.startswith(">JPKZ") or line.startswith(">MIEF") or line.startswith(">LL") or line.startswith(">AWXF") or line.startswith("EQ") or line.startswith(">NW_") or line.startswith(">LWMK") or line.startswith(">NZ_") or line.startswith(">NC_") or line.startswith(">KT"):
			print("in de elif")
			genome = line.split(">")[1].split(",")[0]
			refname = genome.split(" ")[0]
			organismName = genome.split(" ")[1:]
			organism = ' '.join(organismName)
			genomedict[refname] = organism
			
	for item in genomedict.values():
		print(item)		

	return genomedict

#convert the accession numbers to scientific name
def accessionToName(f, genomedict):
	print("Converting accession numbers to scientific names in this file: " + f)
	accession_nrs = []
	bn = basename(f)

	for line in open(f):
		accession_nrs.append(line.split("\t")[0])

	pathogenNames = []
	outputfile = science_names + bn
	openoutput = open(outputfile, "w")

	for number in accession_nrs:
		if number in genomedict:
			pathogenNames.append(genomedict[number])

	for i in pathogenNames:
		openoutput.write(i + "\n")

	openoutput.close()

	outfile = open(outputfile, "r")
	finalpathogenfile = single_names + bn
	openfinalfile = open(finalpathogenfile, "w")

	pathogens = []

	for line in outfile:
		newline = line.split(" ")[:2]
		if newline in pathogens:
			pass
		else:
			pathogens.append(newline)

	for pathogen in pathogens:
		openfinalfile.write(' '.join(pathogen) + "\n")

	openfinalfile.close()

#call all the methods
def main():
	print("*** START ***")
	#makeDirectories()
	#createBowtie2Index()
	#for f in glob.glob(inputfiles):
	#    if "r1" in f:
	#       runBowtie2ToHumanGenome(f)
	#for f in glob.glob(unmappedfiles):
	#for f in glob.glob(inputfiles):
	#	if "_1" in f:
	#		runBowtie2ToPathogens(f)
	#~ for f in glob.glob(sam + "*.sam"):
		#~ samToBam(f)
	#~ for f in glob.glob(bam + "*.bam"):
		#~ removeFailedToAlign(f)
	#~ for f in glob.glob(mapped_bam + "*.bam"):
		#~ getAccessionNumbers(f)
	genomedict = get_Genomes()
	for f in glob.glob(accession + "*.txt"):
		accessionToName(f, genomedict)
	print("*****DONE*****")

if __name__ == "__main__":
	main()
