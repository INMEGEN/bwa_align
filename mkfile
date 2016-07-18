
SORT_INDEX_TARGETS=`{find -L data/ -name '*.fastq.gz' \
	| sed \
		-e 's#data/#results/sort_index/#g' \
		-e 's#_L001_R[12]_001\.fastq\.gz$#\.sorted\.bam\.bai#g' \
	| sort -u \
}

sort_index:V:$SORT_INDEX_TARGETS

results/bwa_align/%.sam:	
	cd alignment
	mk -dep

results/sort_index/%.unsorted.bam:	results/bwa_align/%.sam
	mkdir -p `dirname $target`
	samtools  view -h -b -S $prereq \
	      -o $target

results/sort_index/%.sorted.bam:	results/sort_index/%.unsorted.bam
	mkdir -p `dirname $target`
	samtools sort $prereq \
		-T $prereq.nnnn.bam \
		-o $target

results/sort_index/%.sorted.bam.bai:	results/sort_index/%.sorted.bam
	mkdir -p `dirname $target`
	samtools index $prereq