#!/bin/bash

#SBATCH --job-name=bam   ## Name of the job 
#SBATCH -p free          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=2    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file

directory='/data/class/ecoevo282/swdu/ee282/project/data/processed/'

module load samtools

srun samtools view -S -b SRR121484_$1.sam > SRR121484_$1.bam
