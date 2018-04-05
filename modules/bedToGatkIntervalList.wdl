task bedToGatkIntervalList {
	#https://gist.github.com/beboche/b70c57c7dfe58d4abaed367574bd4f01
	#global variables
	String SrunLow
	String SampleID	
	String OutDir
	String WorkflowType
	#task specific variabless
	String AwkExe
	File IntervalBedFile
	Boolean DirsPrepared
	command <<<
		${SrunLow} ${AwkExe} 'BEGIN {OFS=""} {print $1,":",$2+1,"-",$3}' \
		${IntervalBedFile} \
		> "${OutDir}${SampleID}/${WorkflowType}/gatkIntervals.list"
	>>>
	output {
		File gatkIntervals = "${OutDir}${SampleID}/${WorkflowType}/gatkIntervals.list"
	}
}