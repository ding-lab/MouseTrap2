# Start docker container and run DisambiguateFilter.sh

FQ1="/data2/NIX5.10K.R1.fastq.gz"
FQ2="/data2/NIX5.10K.R2.fastq.gz"
BAM="/data2/human.sort.bam"

HGFA="/data1/GRCh37-lite.fa"
MMFA="/data1/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

OUTDIR="./results"

CMD="/bin/bash src/DisambiguateFilter.sh -1 $FQ1 -2 $FQ2 -h $HGFA -m $MMFA -o $OUTDIR"
#CMD="/bin/bash src/DisambiguateFilter.sh -b $BAM -h $HGFA -m $MMFA -o $OUTDIR"

bash launch_docker.sh $CMD
