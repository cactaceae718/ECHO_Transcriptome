#!/bin/bash
#SBATCH --partition=cpu_short
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --time=12:00:00
#SBATCH --job-name=qsub_htseq

for i in $(ls /gpfs/scratch/caiy02/star_output/re_sampled/)
do
inputpath=/gpfs/scratch/caiy02/star_output/re_sampled/$i
outputpath=/gpfs/scratch/caiy02/ht_seq/re_sampled/$i
mkdir -p $outputpath
sbatch htseq.sh $i $inputpath $outputpath
done
