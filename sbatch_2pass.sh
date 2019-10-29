#!/bin/bash
#SBATCH --partition=cpu_short
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --time=12:00:00
#SBATCH --job-name=sbatch_2pass

cd /gpfs/scratch/caiy02/fastq

for i in $(ls *.R1.fastq.gz)
do
r1=$(echo $i)
r2=$(echo $r1 | sed 's/R1.fastq.gz/R2.fastq.gz/')
o1=$(echo $i | sed 's/.R1.fastq.gz//')

sbatch /gpfs/scratch/caiy02/2pass.sh $r1 $r2 $o1
done