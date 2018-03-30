task prepareWgsTmpDirs {
	#global variables
	String SrunLow
	String SampleID	
	String OutDir
	String WorkflowType
	command {
		mkdir "${OutDir}${SampleID}"
		mkdir "${OutDir}${SampleID}/${WorkflowType}"
		mkdir "${OutDir}${SampleID}/${WorkflowType}/FastqcDir"
		mkdir "${OutDir}${SampleID}/${WorkflowType}/PicardQualityDir"
		mkdir "${OutDir}${SampleID}/${WorkflowType}/splitted_intervals"
		mkdir "${OutDir}${SampleID}/${WorkflowType}/recal_tables"
		mkdir "${OutDir}${SampleID}/${WorkflowType}/recal_bams"
		mkdir "${OutDir}${SampleID}/${WorkflowType}/vcfs"
	}
}