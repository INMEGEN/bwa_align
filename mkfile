<config.mk

# This program uses threads, so we use only one process
NPROC=1

BWA_ALIGN_TARGETS=`{ bin/targets }

bwa_align:V: $BWA_ALIGN_TARGETS

results/bwa_align/%.sam:	\
data/%_R1_001.fastq.gz	\
data/%_R2_001.fastq.gz
	mkdir -p `dirname $target`
	bwa mem \
		-t 1 \
		$REFERENCE \
		$prereq \
		> $target".build" \
	&& mv $target".build" $target

results/bams/%.bam:D:	results/bwa_align/%.sam
	mkdir -p `dirname $target`
	samtools view -h -b -S $prereq \
	      -o $target".build" \
	&& mv $target".build" $target
