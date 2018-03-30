task qualimapBamQc {
	#global variables
	String SrunHigh
	Int Threads
	Int JavaRam
	String SampleID	
	String OutDir
	String WorkflowType
	String QualimapExe
	#task specific variables
	File IntervalBedFile
	File BamFile
	command {
		${SrunHigh} ${QualimapExe} bamqc \
		--java-mem-size=${JavaRam} \
		-bam ${BamFile} \
		-outdir "${OutDir}${SampleID}/${WorkflowType}/qualimap" \
		-c \
		--feature-file ${IntervalBedFile} \
		-nt ${Threads} \
		-sd
	}
}