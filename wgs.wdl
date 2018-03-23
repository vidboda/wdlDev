import "/home/mobidic/Devs/wdlDev/modules/fastqc.wdl" as runFastqc
import "/home/mobidic/Devs/wdlDev/modules/bwaSamtools.wdl" as runBwaSamtools
import "/home/mobidic/Devs/wdlDev/modules/sambambaIndex.wdl" as runSambambaIndex
import "/home/mobidic/Devs/wdlDev/modules/sambambaMarkDup.wdl" as runSambambaMarkDup
import "/home/mobidic/Devs/wdlDev/modules/bedToGatkIntervalList.wdl" as runBedToGatkIntervalList
import "/home/mobidic/Devs/wdlDev/modules/gatkSplitIntervals.wdl" as runGatkSplitIntervals
import "/home/mobidic/Devs/wdlDev/modules/gatkBaseRecalibrator.wdl" as runGatkBaseRecalibrator
import "/home/mobidic/Devs/wdlDev/modules/sambambaFlagStat.wdl" as runSambambaFlagStat
import "/home/mobidic/Devs/wdlDev/modules/gatkCollectMultipleMetrics.wdl" as runGatkCollectMultipleMetrics
import "/home/mobidic/Devs/wdlDev/modules/collectWgsMetricsWithNonZeroCoverage.wdl" as runCollectWgsMetricsWithNonZeroCoverage
import "/home/mobidic/Devs/wdlDev/modules/gatkBedToPicardIntervalList.wdl" as runGatkBedToPicardIntervalList
import "/home/mobidic/Devs/wdlDev/modules/computePoorCoverage.wdl" as runComputePoorCoverage

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
	String workflowType
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
	#gatk splitintervals
	String subdivisionMode
	#gatk Base recal
	File knownSites1
	File knownSites1Index
	File knownSites2
	File knownSites2Index
	File knownSites3
	File knownSites3Index

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
		OutDir = outDir,
		WorkflowType = workflowType
	}
	call runBwaSamtools.bwaSamtools {
		input: 
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
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
		WorkflowType = workflowType,
		SambambaExe = sambambaExe,
		BamFile = bwaSamtools.sortedBam
	}
	call runSambambaMarkDup.sambambaMarkDup {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		SambambaExe = sambambaExe,
		BamFile = bwaSamtools.sortedBam
	}
	call runBedToGatkIntervalList.bedToGatkIntervalList {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		IntervalBedFile = intervalBedFile,
		AwkExe = awkExe
	}
	call runGatkSplitIntervals.gatkSplitIntervals {
		input:
		SrunLow = srunLow,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		RefFasta = refFasta,
		RefFai = refFai,
		RefDict = refDict,
		GatkInterval = bedToGatkIntervalList.gatkIntervals,
		SubdivisionMode = subdivisionMode
	}
	scatter (interval in gatkSplitIntervals.splittedIntervals) {
		call runGatkBaseRecalibrator.gatkBaseRecalibrator {
			input:
			SrunLow = srunLow,
			Threads = threads,
			SampleID = sampleID,
			OutDir = outDir,
			WorkflowType = workflowType,
			GatkExe = gatkExe,
			RefFasta = refFasta,
			RefFai = refFai,
			RefDict = refDict,
			GatkInterval = interval,
			BamFile = sambambaMarkDup.markedBam,
			BamIndex = sambambaMarkDup.markedBamIndex,
			KnownSites1 = knownSites1,
			KnownSites1Index = knownSites1Index,
			KnownSites2 = knownSites2,
			KnownSites2Index = knownSites2Index,
			KnownSites3 = knownSites3,
			KnownSites3Index = knownSites3Index,
		}
	}
	
	call runSambambaFlagStat.sambambaFlagStat {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		SambambaExe = sambambaExe,		
		BamFile = sambambaMarkDup.markedBam
	}
	call runGatkCollectMultipleMetrics.gatkCollectMultipleMetrics {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		RefFasta = refFasta,
		BamFile = sambambaMarkDup.markedBam
	}
#	call runCollectWgsMetricsWithNonZeroCoverage.collectWgsMetricsWithNonZeroCoverage {#too long
#		input:
#		SrunLow = srunLow,
#		SampleID = sampleID,
#		OutDir = outDir,
#		WorkflowType = workflowType,
#		GatkExe = gatkExe,
#		RefFasta = refFasta,
#		BamFile = sambambaMarkDup.markedBam
#	}
	if (isIntervalBedFile) {
		call runGatkBedToPicardIntervalList.gatkBedToPicardIntervalList {
			input:
			SrunLow = srunLow,
			SampleID = sampleID,
			OutDir = outDir,
			WorkflowType = workflowType,
			IntervalBedFile = intervalBedFile,
			RefDict = refDict,
			GatkExe = gatkExe
		}
		call runComputePoorCoverage.computePoorCoverage {
			input:
			SrunLow = srunLow,
			SampleID = sampleID,
			OutDir = outDir,
			WorkflowType = workflowType,
			GenomeVersion = genomeVersion,
			BedToolsExe = bedToolsExe,
			AwkExe = awkExe,
			SortExe = sortExe,
			IntervalBedFile = intervalBedFile,
			BedtoolsLowCoverage = bedtoolsLowCoverage,
			BedToolsSmallInterval = bedToolsSmallInterval,
			BamFile = sambambaMarkDup.markedBam
		}
#		call runGatkDepthOfCoverage.gatkDepthOfCoverage {
#			input:TOBEFINISHED - not implemented yet in gatk4 - must use GATK3
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
			WorkflowType = workflowType,
			GatkExe = gatkExe,
			RefFasta = refFasta,
			RefFai = refFai,
			BamFile = sambambaMarkDup.markedBam,
			BaitIntervals = gatkBedToPicardIntervalList.picardIntervals,
			TargetIntervals = gatkBedToPicardIntervalList.picardIntervals
		}
	}

#	call haplotypeCaller {
#		#to be scattered-gathered see picard splitintervals then pass haplotypecaller an Array[File] - globbed 
#	}
}