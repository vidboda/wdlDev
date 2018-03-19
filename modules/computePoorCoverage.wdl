task computePoorCoverage {
	String SrunLow
	String SampleID
	String OutDir
	String GenomeVersion
	String BedToolsExe	
	File IntervalBedFile
	#task specific variables
	Int BedtoolsLowCoverage
	Int BedToolsSmallInterval
	File BamFile

	command {
		${SrunLow} ${BedToolsExe} genomecov -ibam ${BamFile} -bga | ${AWK} -v low_coverage="${BedtoolsLowCoverage}" '$4<low_coverage' | ${BedToolsExe} intersect -a ${IntervalBedFile} -b - | ${SORT} -k1,1 -k2,2n -k3,3n | ${BedToolsExe} merge -c 4 -o distinct -i - | ${AWK} -v small_intervall="${BedToolsSmallInterval}" 'BEGIN {OFS="\t";print "#chr\tstart\tend\tregion\tsize (bp)\ttype\tUCSC link"} {a=($3-$2+1);if(a<small_intervall) {b="SMALL_INTERVAL"} else {b="OTHER"};url="http://genome-euro.ucsc.edu/cgi-bin/hgTracks?db='${genomeVersion}'&position="$1":"$2-10"-"$3+10"&highlight='${genomeVersion}'."$1":"$2"-"$3;print $0, a, b, url}' > ${OutDir}/${SampleID}/${SampleID}_poor_coverage.txt
	}
	output {
		poorCoverageFile = "${OutDir}/${SampleID}/${SampleID}_poor_coverage.txt"
	}
}