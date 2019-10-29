#!/bin/bash
#SBATCH --partition=cpu_short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=128G
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --job-name=FirstAlignment

module load star/2.5.0c

star_index_path=/gpfs/scratch/caiy02/HG38_INDEX
runThreadN=4

mkdir -p /gpfs/scratch/caiy02/star_output/re_sampled/$3

STAR --genomeDir $star_index_path \
 --readFilesIn $1 $2 \
 --runThreadN $runThreadN \
 --outFilterMultimapScoreRange 1 \
 --outFilterMultimapNmax 20 \
 --outFilterMismatchNmax 10 \
 --alignIntronMax 500000 \
 --alignMatesGapMax 1000000 \
 --sjdbScore 2 \
 --alignSJDBoverhangMin 1 \
 --genomeLoad NoSharedMemory \
 --readFilesCommand zcat \
 --outFilterMatchNminOverLread 0.33 \
 --outFilterScoreMinOverLread 0.33 \
 --sjdbOverhang 100 \
 --outSAMstrandField intronMotif \
 --outSAMtype Non \
 --outSAMmode None \
 --outFileNamePrefix /gpfs/scratch/caiy02/star_output/re_sampled/$3/$3