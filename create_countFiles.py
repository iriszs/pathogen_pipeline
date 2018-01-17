#!/usr/bin/env python3


import sys
import os
from subprocess import call
from os import listdir
import os.path
from os.path import isfile, join
import shutil
import subprocess
import glob
from os.path import basename


alignmentOutput =  ""
sortedAlignmentBam = ""
countFiles = ""
addOrReplace = ""
reordered = ""
markDuplicates =""
genomeIndex = ""
genomeFa = ""
genomeGtf = ""
#global params
fastqFilePath =      '/media/imgorter/6CEC0BDEEC0BA186/imgorter/Fastq/'
#Tools
samtools =           'samtools'
bowtie2 =            'bowtie2'
picard =             '/home/imgorter/lib/picard_2.14.jar'
hisat = 			'/home/imgorter/lib/hisat2-2.1.0-Linux_x86_64/hisat2-2.1.0/hisat2'

#If output dirs not exists: create	
def createDirs():
	if not os.path.isdir(alignmentOutput):
		os.makedirs(alignmentOutput)
	if not os.path.isdir(sortedAlignmentBam):
		os.makedirs(sortedAlignmentBam)
	if not os.path.isdir(countFiles):
		os.makedirs(countFiles)     
	if not os.path.isdir(addOrReplace):
		os.makedirs(addOrReplace)   
	if not os.path.isdir(reordered):
		os.makedirs(reordered)      
	if not os.path.isdir(markDuplicates):
		os.makedirs(markDuplicates)     




#Function that performs an alignment, intermediate steps and converts the BAM to an count file
def Align(fastqf):	
	#Create the commandline commands
	bowtieCommand = bowtie2 + ' -p 32 -x ' + "/home/imgorter/Documents/Human_Genome/Bowtie2_index/human" +  " -1 " + fastqFilePath + fastqf + '_r1.fastq -2 ' + fastqFilePath + fastqf + '_r2.fastq -S ' + alignmentOutput + 'SAM/' + fastqf + '.sam'
	samtoolsCommand = samtools + ' view -Sbo ' + alignmentOutput + fastqf + '_intermediateSteps.bam ' + alignmentOutput + 'SAM/' + fastqf + '.sam'
	deleteSAM = "rm -f " + alignmentOutput + "SAM/" + fastqf + ".sam"


	print("------Aligning------")
	#Check if the output file exists, if not perform command. 

	if not os.path.isfile(alignmentOutput  + fastqf + '_intermediateSteps.bam'):
		print("------Bowtie2------")
		print("working on this file: "+ fastqf)
		os.system(bowtieCommand)
		os.system(samtoolsCommand)
	if os.path.isfile(alignmentOutput + fastqf + "_intermediateSteps.bam"):
		os.system(deleteSAM)
		



def process(fastqf):
	sortCommand = 'java -jar ' + picard + ' SortSam I= ' + alignmentOutput + fastqf + '_intermediateSteps.bam' + ' O= ' + sortedAlignmentBam + fastqf + '_intermediateSteps.bam SO=queryname'
	addOrReplaceCommand = "java -jar " + picard + " AddOrReplaceReadGroups INPUT=" + sortedAlignmentBam + fastqf + "_intermediateSteps.bam OUTPUT=" + addOrReplace + fastqf + "_intermediateSteps.bam " + " LB=" + fastqf + " PU=" + fastqf + " SM=" + fastqf + " PL=illumina CREATE_INDEX=true"
	fixMateInformationCommand = "java -jar " + picard + " FixMateInformation INPUT=" + addOrReplace + fastqf + "_intermediateSteps.bam"
	createSeqDictCommand = "java -jar " + picard + " CreateSequenceDictionary R=" + genomeFa + " O=" + genomeFa.split('.fna')[0] + ".dict"
	reorderSamCommand = "java -jar " + picard + " ReorderSam I=" + addOrReplace + fastqf + "_intermediateSteps.bam O=" + reordered + fastqf  + "_intermediateSteps.bam ALLOW_INCOMPLETE_DICT_CONCORDANCE=true  R=" + genomeFa
	markDuplicatesCommand = "java -jar " + picard + " MarkDuplicates INPUT="+ reordered + fastqf + "_intermediateSteps.bam OUTPUT=" + markDuplicates + fastqf + "_intermediateSteps.bam " + " CREATE_INDEX=true METRICS_FILE=" + markDuplicates + fastqf + "_intermediateSteps.metrics.log"
	sortCommand2 = 'java -jar ' + picard + ' SortSam I= ' + markDuplicates + fastqf + '_intermediateSteps.bam' + ' O= ' + sortedAlignmentBam + fastqf + '_intermediateSteps_sorted.bam SO=queryname'
	
	#Hisat 0.61
	htseqCommand = 'htseq-count -f bam -r name -i gene ' + sortedAlignmentBam + fastqf + '_intermediateSteps_sorted.bam -s no ' + genomeGtf + ' > ' + countFiles  + fastqf + '.txt'
	deleteCommand = 'rm ' + sortedAlignmentBam + fastqf + '_intermediateSteps.bam'
	
	print("------Sort 1------")
	os.system(sortCommand)
		
	print("------add or replace------")
	os.system(addOrReplaceCommand)
		
	print("------fixmate------")
	os.system(fixMateInformationCommand)

	print("-----Create seq dict-----")
	os.system(createSeqDictCommand)
		
	print("------reorder------")
	os.system(reorderSamCommand)
		
	print("------mark duplicates------")
	os.system(markDuplicatesCommand)

	print("------sort 2------")
	os.system(sortCommand2)		

	print("------htseq------")
	os.system(htseqCommand)

	
def main():    
	print("------START------")
	global alignmentOutput
	global sortedAlignmentBam
	global countFiles
	global addOrReplace
	global reordered
	global markDuplicates
	global genomeIndex
	global genomeFa
	global genomeGtf
	alignmentOutput =    '/media/imgorter/1TB_Seagate/Alignment/'
	sortedAlignmentBam = '/media/imgorter/1TB_Seagate/Alignment_sorted/'
	countFiles =         '/media/imgorter/1TB_Seagate/Counts/'
	addOrReplace =       '/media/imgorter/1TB_Seagate/AddOrReplace/'
	reordered =          '/media/imgorter/1TB_Seagate/Reordered/'
	markDuplicates =     '/media/imgorter/1TB_Seagate/MarkDuplicates/'
	genomeIndex =        '/home/imgorter/Documents/Human_Genome/Bowtie2_index/human'
	genomeFa =           '/home/imgorter/Documents/Human_Genome/GRCh38_latest_genomic.fna'
	genomeGtf = 		'/home/imgorter/Documents/Human_Genome/human_genome.gff'
	createDirs()
	for f in glob.glob(fastqFilePath+'*.fastq'):
		if "_r1" in f:
			filename = basename(f)
			basefilename = filename.split("_r1")
	for f in glob.glob("/media/imgorter/1TB_Seagate/Alignment/*.bam"):
		filename=basename(f)
		basefilename = filename.split("_intermediateSteps.bam")
		process(basefilename[0])
		


if __name__ == "__main__":
	main()
