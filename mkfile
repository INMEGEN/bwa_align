<bwa_align.mk

BWA_ALIGN_TARGETS=`{find -L data/ -name '*.fastq.gz' \
	| sed \
		-e 's#data/#results/bwa_align/#g' \
		-e 's#_L001_R[12]_001\.fastq\.gz$#.sorted.bam.bai#g' \
	| sort -u \
}

bwa_align:V: $BWA_ALIGN_TARGETS

NPROC=1
results/bwa_align/%.sam:	data/%_L001_R1_001.fastq.gz	data/%_L001_R2_001.fastq.gz
	mkdir -p `dirname $target`
	bwa mem \
		-t $THREADS \
		$REFERENCE \
		$prereq \
		> $target

NPROC=$THREADS
results/bwa_align/%.bam:	results/bwa_align/%.sam
	mkdir -p `dirname $target`
	samtools  view -h -b -S $prereq \
	      -o $target

results/bwa_align/%.sorted.bam:	results/bwa_align/%.bam
	mkdir -p `dirname $target`
	samtools sort $prereq \
		-T $prereq.nnnn.bam \
		-o $target

results/bwa_align/%.sorted.bam.bai:	results/bwa_align/%.sorted.bam
	mkdir -p `dirname $target`
	samtools index $prereq