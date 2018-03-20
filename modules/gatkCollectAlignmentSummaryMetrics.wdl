task gatkCollectAlignmentSummaryMetrics {
	#https://software.broadinstitute.org/gatk/documentation/tooldocs/current/picard_analysis_CollectAlignmentSummaryMetrics.php
	#global variables
	String SrunLow
	String SampleID
	String OutDir
	String GatkExe
	File RefFasta
	#task specific variables
	File BamFile
	command {
		mkdir "${OutDir}${SampleID}/PicardQualityDir"
		${SrunLow} ${GatkExe} CollectAlignmentSummaryMetrics \
		-R ${RefFasta} \
		-I ${BamFile} \
		-O "${OutDir}${SampleID}/PicardQualityDir/${SampleID}_alignment_summary.txt"
	}
	output {
		File alignmentSummary = "${OutDir}${SampleID}/PicardQualityDir/${SampleID}_alignment_summary.txt"
	}
}