task computeCoverage {
	String SrunLow
	String SampleID
	String OutDir
	String WorkflowType
	String AwkExe
	String SortExe
	String SamtoolsExe
	#task specific variables
	File IntervalBedFile
	File BamFile
	Int MinCovBamQual

	command <<<
		${SrunLow} ${SamtoolsExe} bedcov -Q ${MinCovBamQual} ${IntervalBedFile} ${BamFile} \
		| ${SortExe} -k1,1 -k2,2n -k3,3n \
		| ${AwkExe}  'BEGIN {OFS="\t"}{a=($3-$2+1);b=($7/a);print $1,$2,$3,$4,b,"+"}' \
		| ${AwkExe} 'BEGIN{FS=",.";OFS="\t"}{print $1,"+" }' \
		> "${OutDir}/${SampleID}/${WorkflowType}/${SampleID}_coverage.tsv"
	>>>
	output {
		File CoverageFile = "${OutDir}/${SampleID}/${WorkflowType}/${SampleID}_coverage.tsv"
	}
}
