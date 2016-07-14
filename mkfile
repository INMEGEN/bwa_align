<align.mk

ALIGN_TARGETS=`{find -L data/ -name '*.fastq.gz' \
	| sed \
		-e 's#data/#results/align/#g' \
		-e 's#_L001_R[12]_001\.fastq\.gz$#.sorted.bam.bai#g' \
	| sort -u \
}

align:V: $ALIGN_TARGETS

results/align/%.sam:	data/%_L001_R1_001.fastq.gz	data/%_L001_R2_001.fastq.gz
	bwa mem \
		-t $THREADS \
		$REFERENCE \
		$prereq \
		> $target

results/align/%.bam:	results/align/%.sam
	samtools  view -h -b -S $prereq \
	      -o $target

results/align/%.sorted.bam:	results/align/%.bam
	samtools sort $prereq \
		-T $prereq.nnnn.bam \
		-o $target

results/align/%.sorted.bam.bai:	results/align/%.sorted.bam
	mkdir -p `dirname $target`
	samtools index $prereq