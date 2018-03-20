task gatkBedToPicardIntervalList {
	#global variables
	String SrunLow
	String SampleID
	String OutDir
	File IntervalBedFile
	String GatkExe
	#task specific variables
	File RefDict
	command {
		cp ${IntervalBedFile} "${OutDir}${SampleID}/Intervals.bed"
		${SrunLow} ${GatkExe} BedToIntervalList \
		-I ${IntervalBedFile} \
		-O "${OutDir}${SampleID}/Intervals.Picard.list" \
		-SD ${RefDict}
	}
	output {
		File picardIntervals = "${OutDir}${SampleID}/Intervals.Picard.list"
	}
}