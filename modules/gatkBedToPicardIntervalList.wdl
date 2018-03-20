task gatkBedToPicardIntervalList {
	#https://software.broadinstitute.org/gatk/documentation/tooldocs/current/picard_util_BedToIntervalList.php
	#global variables
	String SrunLow
	String SampleID
	String OutDir
	String WorkflowType
	File IntervalBedFile
	String GatkExe
	#task specific variables
	File RefDict
	command {
		cp ${IntervalBedFile} "${OutDir}${SampleID}/${WorkflowType}/Intervals.bed"
		${SrunLow} ${GatkExe} BedToIntervalList \
		-I ${IntervalBedFile} \
		-O "${OutDir}${SampleID}/${WorkflowType}/picard.interval_list" \
		-SD ${RefDict}
	}
	output {
		File picardIntervals = "${OutDir}${SampleID}/${WorkflowType}/picard.interval_list"
	}
}