#!/bin/bash
#SBATCH --partition=cpu_medium
#SBATCH --nodes=1
#SBATCH --mem=256G
#SBATCH --time=12:00:00
#SBATCH --job-name=intermediate_index

#Intermediate index generation

module load star/2.5.0c

runThreadN=4
sample=$1
outputpath=$2
reference=/gpfs/scratch/caiy02/Homo_sapiens.GRCh38.dna.primary_assembly.fa

STAR --runMode genomeGenerate \
 --genomeDir $outputpath/$sample \
 --genomeFastaFiles $reference \
 --sjdbOverhang 100 \
 --runThreadN $runThreadN \
 --sjdbFileChrStartEnd $outputpath/$sample/${sample}SJ.out.tab