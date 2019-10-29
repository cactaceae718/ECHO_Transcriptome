#!/bin/bash
#SBATCH --partition=cpu_medium
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=128G
#SBATCH --cpus-per-task=1
#SBATCH --time=3-00:00:00
#SBATCH --job-name=Generate Genome Index

# unzip reference gene Hg38 since already download to directory
# gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
# run STAR to generate genome indices specifying correct path to the genome FASTA and annotations GTF file

module load star/2.5.0c

mkdir HG38_index

STAR --runThreadN 4 \
 --runMode genomeGenerate \
 --genomeDir HG38_index \
 --genomeFastaFiles ./Homo_sapiens.GRCh38.dna.primary_assembly.fa \
 --sjdbOverhang 100 \
 --sjdbGTFfile ./Homo_sapiens.GRCh38.93.gtf