task bcftoolsNorm {
	#global variables
	String SrunLow
	String SampleID	
	String OutDir
	String WorkflowType
	String BcfToolsExe
	#task specific variables
	File SortedVcf
	command {
		${SrunLow} ${BcfToolsExe} norm _o v -m - \
		-o "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.norm.vcf" \
		${SortedVcf}
	}
	output {
		File normVcf = "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.norm.vcf"
		File normVcfIndex = "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.norm.vcf.idx"
	}
}