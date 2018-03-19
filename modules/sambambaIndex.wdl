task sambambaIndex {
	#global variables
	String SrunHigh
	Int Threads
	String SampleID	
	String OutDir
	String SambambaExe
	#task specific variables
	File BamFile
	command {
		${SrunHigh} ${SambambaExe} index -t ${Threads} ${BamFile} "${OutDir}${SampleID}/${SampleID}.bam.bai"
	}
	output {
		File bamIndex = "${OutDir}${SampleID}/${SampleID}.bam.bai"
	}
}