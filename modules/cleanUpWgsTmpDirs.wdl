task cleanUpWgsTmpDirs {
	#global variables
	String SrunLow
	String SampleID	
	String OutDir
	String WorkflowType
	command {
		rm -r "${OutDir}${SampleID}/${WorkflowType}/splitted_intervals"
		rm -r "${OutDir}${SampleID}/${WorkflowType}/recal_tables"
		rm -r "${OutDir}${SampleID}/${WorkflowType}/recal_bams"
		rm -r "${OutDir}${SampleID}/${WorkflowType}/vcfs"
	}
}