#workflow to test remote execution of jobs
#unconclusive
#would need to scp inputs and outputs at each step
#or to put all commands in a unique task - don't need a workflow manager for that

workflow testFastqc_remote {
	call fastqc
}

task fastqc {
	File fastqR1
	File fastqR2
	Int threads
	#String tmp_dir => becomes unnecessary with cromwell
	#String out_dir => becomes unnecessary with cromwell
	String fastqc
	String sampleID
	String suffix
	String sshKey
	String remoteAddress
	String remoteLocation
	String srun
	command {
		scp -i ${sshKey} ${fastqR1} ${remoteAddress}:${remoteLocation}
		scp -i ${sshKey} ${fastqR1} ${remoteAddress}:${remoteLocation}
		ssh -i ${sshKey} ${remoteAddress} "${srun} ${fastqc} --threads ${threads} ${remoteLocation}${sampleID}_R1.fastq.gz ${remoteLocation}${sampleID}_R2.fastq.gz"
	}
	#output {
	#	File fastqcHtml = "${sampleID}${suffix}_fastqc.html"
	#}
}