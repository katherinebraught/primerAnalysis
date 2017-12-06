#!/bin/bash

# Copy/paste this job script into a text file and submit with the command:
#    sbatch thefilename
# job standard output will go to the file slurm-%j.out (where %j is the job ID)

#SBATCH --time=04:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 16 processor core(s) per node 
#SBATCH --mem=16G   # maximum memory per node

module load ncbi-blast
module load java

BARESEQUENCEFILE=seq.txt #name of sequence file as a text file not in fast

DATABASE=/work/LAS4/thomasp-lab/kbraught/B73db/Zea_mays.AGPv4.dna.genome.fa #path to database to blast it all to

PREFIX="test" #leave quotes around it

java -jar ./slidingWindow.jar $BARESEQUENCEFILE $PREFIX.outMers $PREFIX.fsa $PREFIX 1

blastn -db $DATABASE -query $PREFIX.outMers -out $PREFIX.blastOut -task blastn-short -outfmt "7 sstart" -evalue .006

FINALHIT=$( cat $PREFIX.blastOut | grep "hits" | tail -1 | sed "s/[^0-9]//g" )

java -jar ./tabularFeaturesCreator.jar $PREFIX.blastOut $FINALHIT null $PREFIX

./tbl2asn -t template.sbt -p . -j "[organism=$PREFIX]" -V vb

mkdir results.$PREFIX

mv $PREFIX* results.$PREFIX
