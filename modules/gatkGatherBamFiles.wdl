task gatkGatherBamFiles {
	String SrunLow
	String SampleID
	String OutDir
	String WorkflowType
	String GatkExe
	Array[File] LAlignedBams
	command {
		${SrunLow} ${GatkExe} GatherBamFiles \
		-I ${sep=' -I ' LAlignedBams} \
		-O "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.dupmarked.recal.laligned.bam"
	}
	output {
		File finalBam = "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.dupmarked.recal.laligned.bam"
		File finalBamIndex = "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.dupmarked.recal.laligned.bam.bai"
	}
}