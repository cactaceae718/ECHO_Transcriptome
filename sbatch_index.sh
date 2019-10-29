#!/bin/bash
#SBATCH --partition=cpu_medium
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --time=3-00:00:00
#SBATCH --job-name=q=sbatch_inter

cd /gpfs/scratch/caiy02/fastq

for i in $(cat 'submap.txt')
do
sample=$(echo $i | sed 's/.R1.fastq.gz//')

outputpath=/gpfs/scratch/caiy02/star_output/re_sampled

sbatch /gpfs/scratch/caiy02/inter_index.sh $sample $outputpath

done