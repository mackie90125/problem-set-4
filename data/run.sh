#! usr/bin/env bash

# this run.sh file must be in the same directory as all the data files

# define data directory path
data='/home/ryan/MOLB-7621/problem-set-4/data'

# need to unzip .fa.gz file before starting

# build index files
bowtie2-build $data/hg19.chr1.fa hg19.chr1

# align to genome, and sorting
 bowtie2 -x hg19.chr1 -U $data/factorx.chr1.fq.gz | samtools sort -o factorx.sort.bam

# create bedgraph file
bedtools genomecov -ibam $data/factorx.sort.bam -g $data/hg19.chrom.sizes -bg > factorx.bg

# create bigwig file
bedGraphToBigWig $data/factorx.bg $data/hg19.chrom.sizes factorx.bw

# peak calling
macs2 callpeak -t $data/factorx.sort.bam



#### concensus binding sequence
# make all peaks 200bp
bedtools slop -i NA_summits.bed -g hg19.chrom.sizes -b 100  > peaks.200.bed

# fasta sequence
bedtools getfasta -fi hg19.chr1.fa -bed peaks.200.bed -fo peaks.200.fa

## WARNING ##
## may take hours to run ##
meme -o meme_200_allpeaks -nmotifs 1 -maxw 20 -minw 8 -dna -maxsize 1000000000 peaks.200.fa

# extract motif
meme-get-motif -id 1 meme_200_allpeaks/meme.txt > meme_200_allpeaks/meme-motif.txt

# enter letter-probability matrix into TOMTOM motif matching website
# first two best matches are CTCF



#### create new git branch
# git branch gh-pages
# git push origin gh-pages
# git checkout gh-pages
# git add, commit, push factorx.bw
