<config.mk

# This program uses threads, so we use only one process
NPROC=1

BWA_ALIGN_TARGETS=`{ bin/targets }

bwa_align:V: $BWA_ALIGN_TARGETS

results/bwa_align/%.sam	\
results/%.sam.log: data/%_L001_R1_001.fastq.gz data/%_L001_R2_001.fastq.gz
	mkdir -p `dirname $target`
	READGROUP=`echo $stem | bin/extract-fastq-data`
	bwa mem \
		-t $PROCESSORS \
		-M \
		-R $READGROUP \
		$REFERENCE \
		$prereq \
		> $target".build" 2> $target".log.build" \
	&& mv $target".build" $target
	&& mv $target".log.build" $target".log"

##Sam to bam conversion
results/%.bam : results/%.sam
	samtools view \
		-b \
		-S $prereq > $target".build" \
	&& mv $target".build" $target

##Ordering BAMs by chromosome coordinate
results/%.sorted.bam : results/%.bam
	picard-tools SortSam \
		I=$prereq \
		O=$target".build" \
		SO=coordinate \
	&& mv $target".build" $target