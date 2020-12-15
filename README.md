# This folder has Shell and R scripts for HPC NYU Langone Bigpurple (SLURM)
# Project: ECHO_EWAS Transcriptome Data

Workflow
1.	Quality control analysis: FASTQC (Shell)

2.	Alignment: STAR (Spliced Transcripts Alignment to a Reference 2.5.0c) (Shell)
Use two-pass mode
Step1 Generate reference index (refer HG38_index.sh)
Step2 First pass: the novel junctions are detected and inserted into the genome indices (refer sbatch_1pass.sh to parallelly run 1stPass.sh)
Step3 Generate intermediate index: (refer sbatch_index.sh to parallelly run inter_index.sh)
Step4 Second pass: all reads will be re-mapped using annotated (from reference) and novel (detected in the first pass) junctions (refer sbatch_2pass.sh to parallelly run 2stPass.sh)

3.	Annotation and quantification: SAMtools (hg38) (Shell)

4.	Differential methylation analysis: DESeq2 (refer DESeq2.r)
