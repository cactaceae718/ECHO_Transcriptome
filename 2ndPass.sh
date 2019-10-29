#!/bin/bash
#SBATCH --partition=cpu_short
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=128G
#SBATCH --time=12:00:00
#SBATCH --job-name=SecondAlignment

module load star/2.5.0c

outputpath=/gpfs/scratch/caiy02/star_output/re_sampled/$3

STAR --genomeDir $outputpath \
 --readFilesIn $1 $2 \
 --runThreadN 4 \
 --outFilterMultimapScoreRange 1 \
 --outFilterMultimapNmax 20 \
 --outFilterMismatchNmax 10 \
 --alignIntronMax 500000 \
 --alignMatesGapMax 1000000 \
 --sjdbScore 2 \
 --alignSJDBoverhangMin 1 \
 --genomeLoad NoSharedMemory \
 --limitBAMsortRAM 0 \
 --readFilesCommand zcat \
 --outFilterMatchNminOverLread 0.33 \
 --outFilterScoreMinOverLread 0.33 \
 --sjdbOverhang 100 \
 --outSAMstrandField intronMotif \
 --outSAMattributes NH HI NM MD AS XS \
 --outSAMunmapped Within \
 --outSAMtype BAM SortedByCoordinate \
 --outSAMheaderHD @HD VN:1.4 \
 --outFileNamePrefix $outputpath/$3.                                           