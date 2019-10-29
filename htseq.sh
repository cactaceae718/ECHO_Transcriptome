#!/bin/bash
#SBATCH --partition=cpu_short
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --time=12:00:00
#SBATCH --job-name=htseq

module load samtools/1.3
module load python/cpu/2.7.15

sample_prefix=$1
inputpath=$2
outputpath=$3
inputbam=$inputpath/$1.Aligned.sortedByCoord.out.bam
reference=/gpfs/scratch/caiy02/Homo_sapiens.GRCh38.93.gtf

samtools view -F 4 $inputbam | htseq-count -m intersection-nonempty -i gene_name --order=name -s no - $reference >$outputpath/${1}.htseq.counts
