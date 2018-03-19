import "/home/mobidic/Devs/wdlDev/modules/fastqc.wdl" as runFastqc
import "/home/mobidic/Devs/wdlDev/modules/bwaSamtools.wdl" as runBwaSamtools
import "/home/mobidic/Devs/wdlDev/modules/sambambaIndex.wdl" as runSambambaIndex
import "/home/mobidic/Devs/wdlDev/modules/computePoorCoverage.wdl" as runComputePoorCoverage

workflow wgs {
	#global
	String srunHigh
	String srunLow
	Int threads
	String sampleID
	String suffix1
	String suffix2
	File fastqR1
	File fastqR2	
	File refFasta
	File refFai
	Boolean isIntervalBedFile
	File intervalBedFile
	#execs
	String samtoolsExe
	String sambambaExe
	String bedToolsExe
	String awkExe
	String sortExe
	#fastqc	
	String fastqcExe
	String outDir
	#bwaSamtools
	String bwaExe
	String platform
	File refAmb
	File refAnn
	File refBwt
	File refPac
	File refSa
	#computePoorCoverage


	call runFastqc.fastqc {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		Suffix1 = suffix1,
		Suffix2 = suffix2,
		FastqR1 = fastqR1,
		FastqR2 = fastqR2,
		FastqcExe = fastqcExe,
		OutDir = outDir
	}
	call runBwaSamtools.bwaSamtools {
		input: 
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,		
		FastqR1 = fastqR1,
		FastqR2 = fastqR2,
		SamtoolsExe = samtoolsExe,
		BwaExe = bwaExe,
		Platform = platform,
		RefFasta = refFasta,
		RefFai = refFai,
		RefAmb = refAmb,
		RefAnn = refAnn,
		RefBwt = refBwt,
		RefPac = refPac,
		RefSa = refSa
	}
	call runSambambaIndex.sambambaIndex {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		SambambaExe = sambambaExe,
		BamFile = bwaSamtools.sortedBam
	}
	if (isIntervalBedFile) {
		call runComputePoorCoverage.computePoorCoverage {
			input:
			SrunLow = srunLow,
			SampleID = sampleID,
			OutDir = outDir,
			GenomeVersion = genomeVersion,
			BedToolsExe = bedToolsExe,
			IntervalBedFile = intervalBedFile,
			BedtoolsLowCoverage = bedtoolsLowCoverage,
			BedToolsSmallInterval = bedToolsSmallInterval,
			BamFile = bwaSamtools.sortedBam
		}
		call collectHsMetrics {

		}
#		call collectInsertSizeMetrics {
#
#		}
	}
#	call haplotypeCallerERC {
#
#	}
}