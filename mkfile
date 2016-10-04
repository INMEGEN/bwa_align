
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

results/unsorted/%.bam:D:	results/bwa_align/%.sam
	mkdir -p `dirname $target`
	samtools  view -h -b -S $prereq \
	      > $target

results/sort_index/%.sorted.bam:D:	results/unsorted/%.bam
	mkdir -p `dirname $target`
	samtools sort -f $prereq \
		$target

results/sort_index/%.sorted.bam.bai:D:	results/sort_index/%.sorted.bam
	mkdir -p `dirname $target`
	samtools index $prereq
