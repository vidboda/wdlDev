task gatkGatherVcfs {
	#global variables
	String SrunLow
	String SampleID	
	String OutDir
	String WorkflowType
	String GatkExe	
	#task specific variables
	Array[File] HcVcfs
	command {
		${SrunLow} ${GatkExe} GatherVcfs \
		-I ${sep=' -I ' HcVcfs} \
		-O "${OutDir}${SampleID}/${WorkflowType}/vcfs/${SampleID}.vcf"

		rm -r "${OutDir}${SampleID}/${WorkflowType}/vcfs"
	}
	output {
		File gatheredHcVcf = "${OutDir}${SampleID}/${WorkflowType}/vcfs/${SampleID}.vcf"
	}
}