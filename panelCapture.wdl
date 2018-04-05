import "/home/mobidic/Devs/wdlDev/modules/preparePanelCaptureTmpDirs.wdl" as runPreparePanelCaptureTmpDirs
import "/home/mobidic/Devs/wdlDev/modules/fastqc.wdl" as runFastqc
import "/home/mobidic/Devs/wdlDev/modules/bwaSamtools.wdl" as runBwaSamtools
import "/home/mobidic/Devs/wdlDev/modules/sambambaIndex.wdl" as runSambambaIndex
import "/home/mobidic/Devs/wdlDev/modules/sambambaMarkDup.wdl" as runSambambaMarkDup
import "/home/mobidic/Devs/wdlDev/modules/bedToGatkIntervalList.wdl" as runBedToGatkIntervalList
import "/home/mobidic/Devs/wdlDev/modules/gatkSplitIntervals.wdl" as runGatkSplitIntervals
import "/home/mobidic/Devs/wdlDev/modules/gatkBaseRecalibrator.wdl" as runGatkBaseRecalibrator
import "/home/mobidic/Devs/wdlDev/modules/gatkGatherBQSRReports.wdl" as runGatkGatherBQSRReports
import "/home/mobidic/Devs/wdlDev/modules/gatkApplyBQSR.wdl" as runGatkApplyBQSR
import "/home/mobidic/Devs/wdlDev/modules/gatkLeftAlignIndels.wdl" as runGatkLeftAlignIndels
import "/home/mobidic/Devs/wdlDev/modules/gatkGatherBamFiles.wdl" as runGatkGatherBamFiles
import "/home/mobidic/Devs/wdlDev/modules/sambambaFlagStat.wdl" as runSambambaFlagStat
import "/home/mobidic/Devs/wdlDev/modules/gatkCollectMultipleMetrics.wdl" as runGatkCollectMultipleMetrics
import "/home/mobidic/Devs/wdlDev/modules/gatkCollectInsertSizeMetrics.wdl" as runGatkCollectInsertSizeMetrics
#import "/home/mobidic/Devs/wdlDev/modules/collectWgsMetricsWithNonZeroCoverage.wdl" as runCollectWgsMetricsWithNonZeroCoverage
import "/home/mobidic/Devs/wdlDev/modules/gatkBedToPicardIntervalList.wdl" as runGatkBedToPicardIntervalList
import "/home/mobidic/Devs/wdlDev/modules/computePoorCoverage.wdl" as runComputePoorCoverage
import "/home/mobidic/Devs/wdlDev/modules/samtoolsBedCov.wdl" as runSamtoolsBedCov
import "/home/mobidic/Devs/wdlDev/modules/computeCoverage.wdl" as runComputeCoverage
import "/home/mobidic/Devs/wdlDev/modules/computeCoverageClamms.wdl" as runComputeCoverageClamms
import "/home/mobidic/Devs/wdlDev/modules/gatkCollectHsMetrics.wdl" as runGatkCollectHsMetrics
import "/home/mobidic/Devs/wdlDev/modules/gatkHaplotypeCaller.wdl" as runGatkHaplotypeCaller
import "/home/mobidic/Devs/wdlDev/modules/gatkGatherVcfs.wdl" as runGatkGatherVcfs
import "/home/mobidic/Devs/wdlDev/modules/qualimapBamQc.wdl" as runQualimapBamQc
import "/home/mobidic/Devs/wdlDev/modules/jvarkitVcfPolyX.wdl" as runJvarkitVcfPolyX
import "/home/mobidic/Devs/wdlDev/modules/gatkSplitVcfs.wdl" as runGatkSplitVcfs
import "/home/mobidic/Devs/wdlDev/modules/gatkVariantFiltrationSnp.wdl" as runGatkVariantFiltrationSnp
import "/home/mobidic/Devs/wdlDev/modules/gatkVariantFiltrationIndel.wdl" as runGatkVariantFiltrationIndel
import "/home/mobidic/Devs/wdlDev/modules/gatkMergeVcfs.wdl" as runGatkMergeVcfs
import "/home/mobidic/Devs/wdlDev/modules/gatkSortVcf.wdl" as runGatkSortVcf
import "/home/mobidic/Devs/wdlDev/modules/bcftoolsNorm.wdl" as runBcftoolsNorm
import "/home/mobidic/Devs/wdlDev/modules/compressIndexVcf.wdl" as runCompressIndexVcf
import "/home/mobidic/Devs/wdlDev/modules/cleanUpPanelCaptureTmpDirs.wdl" as runCleanUpPanelCaptureTmpDirs

workflow panelCapture {
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
	File intervalBedFile
	String workflowType
	#bioinfo execs
	String samtoolsExe
	String sambambaExe
	String bedToolsExe
	String qualimapExe
	String bcfToolsExe
	String bgZipExe
	String tabixExe
	#standard execs
	String awkExe
	String sortExe
	String javaRam
	String gatkExe
	String javaExe
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
	#sambambaIndex
	String suffixIndex
	String suffixIndex2
	#gatk splitintervals
	String subdivisionMode
	#gatk Base recal
	File knownSites1
	File knownSites1Index
	File knownSites2
	File knownSites2Index
	File knownSites3
	File knownSites3Index
	#gatherVcfs
	String vcfHcSuffix
	String vcfSISuffix
	#gatk-picard
	File refDict
	#computePoorCoverage
	Int bedtoolsLowCoverage
	Int bedToolsSmallInterval
	#computeCoverage
	Int minCovBamQual
	#haplotypeCaller
	String swMode
	#jvarkit
	String vcfPolyXJar

	call runPreparePanelCaptureTmpDirs.preparePanelCaptureTmpDirs {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType
	}
	#if (preparePanelCaptureTmpDirs.dirsPrepared) {
	call runFastqc.fastqc {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		FastqcExe = fastqcExe,
		FastqR1 = fastqR1,
		FastqR2 = fastqR2,
		Suffix1 = suffix1,
		Suffix2 = suffix2,
		DirsPrepared = preparePanelCaptureTmpDirs.dirsPrepared
	}
	#}
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
		BamFile = bwaSamtools.sortedBam,
		SuffixIndex = suffixIndex
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
		AwkExe = awkExe,
		DirsPrepared = preparePanelCaptureTmpDirs.dirsPrepared
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
			KnownSites3Index = knownSites3Index
		}
	}
	output {
			Array[File] recalTables = gatkBaseRecalibrator.recalTable
	}
	call runGatkGatherBQSRReports.gatkGatherBQSRReports {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		RecalTables = recalTables
	}
	scatter (interval in gatkSplitIntervals.splittedIntervals) {
		call runGatkApplyBQSR.gatkApplyBQSR {
			input:
			SrunLow = srunLow,
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
			GatheredRecaltable = gatkGatherBQSRReports.gatheredRecalTable
		}
		call runGatkLeftAlignIndels.gatkLeftAlignIndels {
			input:
			SrunLow = srunLow,
			SampleID = sampleID,
			OutDir = outDir,
			WorkflowType = workflowType,
			GatkExe = gatkExe,
			RefFasta = refFasta,
			RefFai = refFai,
			RefDict = refDict,
			GatkInterval = interval,
			BamFile = gatkApplyBQSR.recalBam
		}
	}
	output {
			Array[File] lAlignedBams = gatkLeftAlignIndels.lAlignedBam
	}
	call runGatkGatherBamFiles.gatkGatherBamFiles {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		LAlignedBams = lAlignedBams
	}
	call runSambambaIndex.sambambaIndex as finalIndexing {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		SambambaExe = sambambaExe,
		BamFile = gatkGatherBamFiles.finalBam,
		SuffixIndex = suffixIndex2
	}
	call runSambambaFlagStat.sambambaFlagStat {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		SambambaExe = sambambaExe,		
		BamFile = gatkGatherBamFiles.finalBam
	}
	call runGatkCollectMultipleMetrics.gatkCollectMultipleMetrics {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		RefFasta = refFasta,
		BamFile = gatkGatherBamFiles.finalBam
	}
	call runGatkCollectInsertSizeMetrics.gatkCollectInsertSizeMetrics {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		RefFasta = refFasta,
		BamFile = gatkGatherBamFiles.finalBam
	}
	call runQualimapBamQc.qualimapBamQc {
		input:
		SrunHigh = srunHigh,
		Threads = threads,
		JavaRam = javaRam,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		QualimapExe = qualimapExe,
		BamFile = gatkGatherBamFiles.finalBam,
		IntervalBedFile = intervalBedFile,
	}
	call runGatkBedToPicardIntervalList.gatkBedToPicardIntervalList {			input:
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
		BamFile = gatkGatherBamFiles.finalBam
	}
	call runSamtoolsBedCov.samtoolsBedCov {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		SamtoolsExe = samtoolsExe,
		IntervalBedFile = intervalBedFile,
		BamFile = gatkGatherBamFiles.finalBam,
		BamIndex = finalIndexing.bamIndex,
		MinCovBamQual = minCovBamQual
	}
	call runComputeCoverage.computeCoverage {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		AwkExe = awkExe,
		SortExe = sortExe,
		BedCovFile = samtoolsBedCov.BedCovFile
	}
	call runComputeCoverageClamms.computeCoverageClamms {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		AwkExe = awkExe,
		SortExe = sortExe,
		BedCovFile = samtoolsBedCov.BedCovFile
	}
	call runGatkCollectHsMetrics.gatkCollectHsMetrics {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
			GatkExe = gatkExe,
		RefFasta = refFasta,
		RefFai = refFai,
		BamFile = gatkGatherBamFiles.finalBam,
		BaitIntervals = gatkBedToPicardIntervalList.picardIntervals,
		TargetIntervals = gatkBedToPicardIntervalList.picardIntervals
	}
	scatter (interval in gatkSplitIntervals.splittedIntervals) {
		call runGatkHaplotypeCaller.gatkHaplotypeCaller {
			input:
			SrunLow = srunLow,
			SampleID = sampleID,
			OutDir = outDir,
			WorkflowType = workflowType,
			GatkExe = gatkExe,
			RefFasta = refFasta,
			RefFai = refFai,
			RefDict = refDict,
			DbSNP = knownSites3,
			DbSNPIndex = knownSites3Index,
			GatkInterval = interval,
			BamFile = gatkGatherBamFiles.finalBam,
			BamIndex = finalIndexing.bamIndex,
			SwMode = swMode
		}
	}
	output {
		Array[File] hcVcfs = gatkHaplotypeCaller.hcVcf
	}
	call runGatkGatherVcfs.gatkGatherVcfs {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		HcVcfs = hcVcfs,
		VcfSuffix = vcfHcSuffix
	}
	call runJvarkitVcfPolyX.jvarkitVcfPolyX {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		RefFasta = refFasta,
		RefFai = refFai,
		RefDict = refDict,
		JavaExe = javaExe,
		VcfPolyXJar = vcfPolyXJar,
		Vcf = gatkGatherVcfs.gatheredHcVcf,
		VcfIndex = gatkGatherVcfs.gatheredHcVcfIndex

	}
	call runGatkSplitVcfs.gatkSplitVcfs {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		Vcf = jvarkitVcfPolyX.polyxedVcf,
		VcfIndex = jvarkitVcfPolyX.polyxedVcfIndex
	}
	call runGatkVariantFiltrationSnp.gatkVariantFiltrationSnp {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		RefFasta = refFasta,
		RefFai = refFai,
		RefDict = refDict,
		Vcf = gatkSplitVcfs.snpVcf,
		VcfIndex = gatkSplitVcfs.snpVcfIndex
	}
	call runGatkVariantFiltrationIndel.gatkVariantFiltrationIndel {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		RefFasta = refFasta,
		RefFai = refFai,
		RefDict = refDict,
		Vcf = gatkSplitVcfs.indelVcf,
		VcfIndex = gatkSplitVcfs.indelVcfIndex
	}
	call runGatkMergeVcfs.gatkMergeVcfs {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		Vcfs = [gatkVariantFiltrationSnp.filteredSnpVcf, gatkVariantFiltrationIndel.filteredIndelVcf],
		VcfSuffix = vcfSISuffix
	}
	call runGatkSortVcf.gatkSortVcf {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		GatkExe = gatkExe,
		UnsortedVcf = gatkMergeVcfs.mergedVcf
	}
	call runBcftoolsNorm.bcftoolsNorm {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		BcfToolsExe = bcfToolsExe,
		SortedVcf = gatkSortVcf.sortedVcf
	}
	call runCompressIndexVcf.compressIndexVcf {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		BgZipExe = bgZipExe,
		TabixExe = tabixExe,
		NormVcf = bcftoolsNorm.normVcf
	}
	String dataPath = "${outDir}${sampleID}/${workflowType}/"
	call runCleanUpPanelCaptureTmpDirs.cleanUpPanelCaptureTmpDirs {
		input:
		SrunLow = srunLow,
		SampleID = sampleID,
		OutDir = outDir,
		WorkflowType = workflowType,
		FinalVcf = compressIndexVcf.bgZippedVcf,
		BamArray = ["${dataPath}" + basename(bwaSamtools.sortedBam), "${dataPath}" + basename(sambambaMarkDup.markedBam), "${dataPath}" + basename(sambambaMarkDup.markedBamIndex)],
		FinalBam = gatkGatherBamFiles.finalBam,
		FinalBamIndex = gatkGatherBamFiles.finalBam,
		VcfArray = ["${dataPath}" + basename(gatkGatherVcfs.gatheredHcVcf), "${dataPath}" + basename(gatkGatherVcfs.gatheredHcVcfIndex), "${dataPath}" + basename(jvarkitVcfPolyX.polyxedVcf), "${dataPath}" + basename(jvarkitVcfPolyX.polyxedVcfIndex), "${dataPath}" + basename(gatkSplitVcfs.snpVcf), "${dataPath}" + basename(gatkSplitVcfs.snpVcfIndex), "${dataPath}" + basename(gatkSplitVcfs.indelVcf), "${dataPath}" + basename(gatkSplitVcfs.indelVcfIndex), "${dataPath}" + basename(gatkVariantFiltrationSnp.filteredSnpVcf), "${dataPath}" + basename(gatkVariantFiltrationSnp.filteredSnpVcfIndex), "${dataPath}" + basename(gatkVariantFiltrationIndel.filteredIndelVcf), "${dataPath}" + basename(gatkVariantFiltrationIndel.filteredIndelVcfIndex), "${dataPath}" + basename(gatkMergeVcfs.mergedVcf), "${dataPath}" + basename(gatkMergeVcfs.mergedVcfIndex), "${dataPath}" + basename(gatkSortVcf.sortedVcf), "${dataPath}" + basename(gatkSortVcf.sortedVcfIndex)]

	}


}