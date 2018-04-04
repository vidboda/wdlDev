task cleanUpWgsTmpDirs {
	#global variables
	String SrunLow
	String SampleID	
	String OutDir
	String WorkflowType
	File FinalVcf
	Array[File] BamArray
	File FinalBam
	Array[File] VcfArray
	command {
		if [ -d "${OutDir}${SampleID}/${WorkflowType}/splitted_intervals" ];then \
			rm -r "${OutDir}${SampleID}/${WorkflowType}/splitted_intervals"; \
		fi
		if [ -d "${OutDir}${SampleID}/${WorkflowType}/recal_tables" ];then \
			rm -r "${OutDir}${SampleID}/${WorkflowType}/recal_tables"; \
		fi
		if [ -d "${OutDir}${SampleID}/${WorkflowType}/recal_bams" ];then \
			rm -r "${OutDir}${SampleID}/${WorkflowType}/recal_bams"; \
		fi
		if [ -d "${OutDir}${SampleID}/${WorkflowType}/vcfs" ];then \
			rm -r "${OutDir}${SampleID}/${WorkflowType}/vcfs"; \
		fi
		rm ${sep=' ' BamArray} 
		rm ${sep=' ' VcfArray}
		mv "${FinalBam}" "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.bam"
		mv "${FinalBam}.bai" "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.bam.bai"
	}
	output {
#		File finalVcf = ${FinalVcf}
		File finalBam = "${OutDir}${SampleID}/${WorkflowType}/${SampleID}.bam"
	}
}