workflow firstSteps {
	#get fastqc and bwa|samtools sort
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
	String sambamba
	String srun

	call fastqc {
		input: 
		Threads = threads,
		FastqR1 = fastqR1,
		FastqR2 = fastqR2,
		OutDir = outDir,
		SampleID = sampleID,
		Suffix = suffix,
		Srun = srun
	}
	call bwaSamtools {
		input: 
		SampleID = sampleID,
		RefFasta = refFasta,
		RefFai = refFai,
		FastqR1 = fastqR1,
		FastqR2 = fastqR2,
		Samtools = samtools,
		Threads = threads,
		OutDir = outDir,
		Srun = srun
	}
	call sambambaMarkDupIndex {
	  	input:
	    SampleID = sampleID,
	    Threads = threads,
	    OutDir = outDir,
	    SortedBam = bwaSamtools.sortedBam,
	    Sambamba = sambamba,
	    Srun = srun
	}
	call sambambaFlagStat {
		input:
		SampleID = sampleID,
		OutDir = outDir,
		Threads = threads,
		MarkedBam = sambambaMarkDupIndex.markedBam,
		Sambamba = sambamba,
		Srun = srun
	}
}

task fastqc {
	#global variables
	String Srun
	Int Threads
	File FastqR1
	File FastqR2
	String OutDir
	String SampleID
	String Suffix
	#task specific variables
	String fastqc
	command {
		mkdir ${OutDir}
		mkdir ${OutDir}FASTQC_DIR
		mkdir ${OutDir}FASTQC_DIR/tmp
		${Srun} ${fastqc} --threads ${Threads} -d ${OutDir}FASTQC_DIR/tmp ${FastqR1} ${FastqR2} -o "${OutDir}FASTQC_DIR"
		rm -r ${OutDir}FASTQC_DIR/tmp
	}
	output {
		File fastqcHtml = "${OutDir}FASTQC_DIR/${SampleID}${Suffix}_fastqc.html"
	}
}

task bwaSamtools {
	#global variables
	String Srun
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
	command {
		${Srun} ${bwa} mem -M -t ${Threads} -R "@RG\tID:${SampleID}\tSM:${SampleID}\tPL:${platform}" ${RefFasta} ${FastqR1} ${FastqR2} | ${Samtools} sort -@ ${Threads} -l 1 -o ${OutDir}/${SampleID}.sorted.bam
	}
	output {
		File sortedBam = "${OutDir}${SampleID}.sorted.bam"
	}
}

task sambambaMarkDupIndex {
	#global variables
	String Srun
	String SampleID
	Int Threads
	String OutDir
	String Sambamba
	#task specific variables
	String tmpDir
	File SortedBam
	command {
		${Srun} ${Sambamba} markdup -t ${Threads} --tmpdir=${tmpDir} -l 1 ${SortedBam} ${OutDir}${SampleID}.sorted.markdup.bam
		rm -r ${tmpDir}
		rm ${SortedBam}
	}
	output {
		File markedBam = "${OutDir}${SampleID}.sorted.markdup.bam"
	}
}

task sambambaFlagStat {
	#global variables
	String Srun
	String SampleID
	Int Threads
	String OutDir
	String Sambamba
	#task specific variables
	File MarkedBam
	command {
		${Srun} ${Sambamba} flagstat -t ${Threads} ${MarkedBam} > ${OutDir}${SampleID}_stats.txt
	}
	output {
		File Stats = "${OutDir}${SampleID}_stats.txt"
	}
}