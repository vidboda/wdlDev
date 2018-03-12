workflow firstSteps {
	#variables usable by multiple tasks
	File fastqR1
	File fastqR2
	Int threads
	String sampleID
	String suffix
	String outDir 
	File refFasta
	#index file for samtools
	File refFai
	String samtools	
	call fastqc {
		input: Threads=threads,
		FastqR1=fastqR1,
		FastqR2=fastqR2,
		OutDir=outDir,
		SampleID=sampleID,
		Suffix=suffix
	}
	call bwaSamtools {
		input: SampleID=sampleID,
		RefFasta=refFasta,
		RefFai=refFai,
		FastqR1=fastqR1,
		FastqR2=fastqR2,
		Samtools=samtools,
		Threads=threads,
		OutDir=outDir,
	}
}

task fastqc {
	#global variables
	Int Threads
	File FastqR1
	File FastqR2
	String OutDir
	String SampleID
	String Suffix
	#task specific variables
	String tmpDir
	String fastqc
	command {
		${fastqc} --threads ${Threads} -d ${tmpDir} ${FastqR1} ${FastqR2} -o "${OutDir}/FASTQC_DIR"
	}
	output {
		File fastqcHtml = "${OutDir}${SampleID}${Suffix}_fastqc.html"
	}
}

task bwaSamtools {
	#global variables
	String SampleID
	File RefFasta
	File RefFai
	File FastqR1
	File FastqR2
	String Samtools
	Int Threads
	String OutDir
	#task specific variables
	String bwa
	String platform
	#index files for bwa
	File refAmb
	File refAnn
	File refBwt
	File refPac
	File refSa


	String outfile
	command {
		${bwa} mem -M -t ${Threads} -R "@RG\tID:${SampleID}\tSM:${SampleID}\tPL:${platform}" ${RefFasta} ${FastqR1} ${FastqR2} | ${Samtools} sort -@ ${Threads} -l 1 -o ${OutDir}/${SampleID}.sorted.bam
	}
	output {
		File sortedBam = "${OutDir}${SampleID}.sorted.bam"
	}
}