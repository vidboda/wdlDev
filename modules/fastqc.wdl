task fastqc {
	String SrunHigh
	Int Threads
	File FastqR1
	File FastqR2
	String SampleID
	String Suffix1
	String Suffix2
	String FastqcExe
	String OutDir
	command {
		mkdir ${OutDir}${SampleID}
		mkdir "${OutDir}${SampleID}/FASTQC_DIR"
		${SrunHigh} ${FastqcExe} --threads ${Threads} ${FastqR1} ${FastqR2} -o "${OutDir}${SampleID}/FASTQC_DIR"
	}
	output {
		File fastqcZipR1 = "${OutDir}${SampleID}/${SampleID}${Suffix1}_fastqc.zip"
		File fastqcHtmlR1 = "${OutDir}${SampleID}/${SampleID}${Suffix1}_fastqc.html"
		File fastqcZipR2 = "${OutDir}${SampleID}/${SampleID}${Suffix2}_fastqc.zip"
		File fastqcHtmlR2 = "${OutDir}${SampleID}/${SampleID}${Suffix2}_fastqc.html"
	}
}