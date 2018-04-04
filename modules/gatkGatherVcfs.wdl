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
		-O "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.vcf"
	}
	output {
		File gatheredHcVcf = "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.vcf"
		File gatheredHcVcfIndex = "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.vcf.idx"
	}
}