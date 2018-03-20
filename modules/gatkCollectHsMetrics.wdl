task gatkCollectHsMetrics {
	#https://software.broadinstitute.org/gatk/documentation/tooldocs/current/picard_analysis_directed_CollectHsMetrics.php
	#global variables
	String SrunLow
	String SampleID
	String OutDir
	String GatkExe
	File RefFasta
	#task specific variables
	File BamFile
	File BaitIntervals
	File TargetIntervals
	command {
		mkdir "${OutDir}${SampleID}/PicardQualityDir"
		${SrunLow} ${GatkExe} CollectHsMetrics \
		-R ${RefFasta} \
		-I ${BamFile} \
		-O "${OutDir}${SampleID}/PicardQualityDir/${SampleID}_hs_metrics.txt" \
		--BAIT_INTERVALS ${BaitIntervals} \
		--TARGET_INTERVALS ${TargetIntervals}
	}
	output {
		File hsMetricsTxt = "${OutDir}${SampleID}/PicardQualityDir/${SampleID}_hs_metrics.txt"
	}
}