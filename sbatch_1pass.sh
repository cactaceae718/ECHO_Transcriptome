#!/bin/bash
#SBATCH --partition=cpu_short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=128G
#SBATCH --time=12:00:00
#SBATCH --job-name=sbatch_1pass

cd /gpfs/scratch/caiy02/fastq

for i in $(ls *.R1.fastq.gz)
do
r1=$(echo $i)  # r1=$(echo '/path1/path2/'$i)
r2=$(echo $r1 | sed 's/R1.fastq.gz/R2.fastq.gz/') # sed is correct; s/ string?; R1.fq.gz/R2.fq.gz/ R1.fa.gz replace R2.fa.gz
o1=$(echo $i | sed 's/.R1.fastq.gz//')

sbatch -p cpu_medium /gpfs/scratch/caiy02/1pass.sh $r1 $r2 $o1
done