import "/home/mobidic/Devs/wdlDev/modules/fastqc.wdl" as runFastqc

workflow wgs {
	#global
	String srun
	Int threads
	String sampleID
	String suffix1
	String suffix2
	#fastqc
	File fastqR1
	File fastqR2	
	String fastqcExe
	String outDir

	call runFastqc.fastqc {
		input:
		Srun = srun,
		Threads = threads,
		SampleID = sampleID,
		Suffix1 = suffix1,
		Suffix2 = suffix2,
		FastqR1 = fastqR1,
		FastqR2 = fastqR2,
		FastqcExe = fastqcExe,
		OutDir = outDir
	}
}