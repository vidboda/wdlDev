import "/home/mobidic/Devs/wdlDev/modules/fastqc.wdl" as runFastqc
import "/home/mobidic/Devs/wdlDev/modules/bwaSamtools.wdl" as runBwaSamtools
import "/home/mobidic/Devs/wdlDev/modules/sambambaIndex.wdl" as runSambambaIndex
import "/home/mobidic/Devs/wdlDev/modules/gatkCollectMultipleMetrics.wdl" as runGatkCollectMultipleMetrics
#import "/home/mobidic/Devs/wdlDev/modules/computePoorCoverage.wdl" as runComputePoorCoverage
import "/home/mobidic/Devs/wdlDev/modules/gatkBedToPicardIntervalList.wdl" as runGatkBedToPicardIntervalList
#import "/home/mobidic/Devs/wdlDev/modules/gatkDepthOfCoverage.wdl" as runGatkDepthOfCoverage
import "/home/mobidic/Devs/wdlDev/modules/gatkCollectHsMetrics.wdl" as runGatkCollectHsMetrics


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
	String genomeVersion
	File refFasta
	File refFai
	Boolean isIntervalBedFile
	File intervalBedFile
	#bioinfo execs
	String samtoolsExe
	String sambambaExe
	String bedToolsExe
	#standard execs
	String awkExe
	String sortExe
	String javaRam
	String gatkExe
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
	Int bedtoolsLowCoverage
	Int bedToolsSmallInterval
	#gatk-picard
	File refDict

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
	#call runGatkCollectAlignmentSummaryMetrics.gatkCollectAlignmentSummaryMetrics {
	#	input:
	#	SrunLow = srunLow,
	#	SampleID = sampleID,
	#	OutDir = outDir,
	#	GatkExe = gatkExe,
	#	RefFasta = refFasta,
	#	BamFile = bwaSamtools.sortedBam
	#}
	call runGatkCollectMultipleMetrics.gatkCollectMultipleMetrics {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		GatkExe = gatkExe,
		RefFasta = refFasta,
		BamFile = bwaSamtools.sortedBam
	}
	if (isIntervalBedFile) {
		call runGatkBedToPicardIntervalList.gatkBedToPicardIntervalList {
			input:
			SrunLow = srunLow,
			SampleID = sampleID,
			OutDir = outDir,
			IntervalBedFile = intervalBedFile,
			RefDict = refDict,
			GatkExe = gatkExe
		}
#		call runComputePoorCoverage.computePoorCoverage {#is not validated with womtool
#			input:
#			SrunLow = srunLow,
#			SampleID = sampleID,
#			OutDir = outDir,
#			GenomeVersion = genomeVersion,
#			BedToolsExe = bedToolsExe,
#			AwkExe = awkExe,
#			SortExe = sortExe,
#			IntervalBedFile = intervalBedFile,
#			BedtoolsLowCoverage = bedtoolsLowCoverage,
#			BedToolsSmallInterval = bedToolsSmallInterval,
#			BamFile = bwaSamtools.sortedBam
#		}
#		call runGatkDepthOfCoverage.gatkDepthOfCoverage {
#			input:TOBEFINISHED
#			SrunLow = srunLow,
#			SampleID = sampleID,
#			OutDir = outDir,
#			JavaExe = javaExe,
#			JavaRam = javaRam,
#			GatkExe = gatkExe,
#			RefFasta = refFasta,
#
#		}
		call runGatkCollectHsMetrics.gatkCollectHsMetrics {
			input:
			SrunLow = srunLow,
			SampleID = sampleID,
			OutDir = outDir,
			GatkExe = gatkExe,
			RefFasta = refFasta,
			RefFai = refFai,
			BamFile = bwaSamtools.sortedBam,
			BaitIntervals = gatkBedToPicardIntervalList.picardIntervals,
			TargetIntervals = gatkBedToPicardIntervalList.picardIntervals
		}
	}
#	call haplotypeCaller {
#		#to be scattered-gathered see picard splitintervals then pass haplotypecaller an Array[File] 
#	}
}