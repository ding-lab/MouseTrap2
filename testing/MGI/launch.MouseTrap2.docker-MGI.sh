# Launch docker container and run MouseTrap2.  Specific to MGI

# Arguments
# -b BAM: Pass BAM to be processed
# -1 FQ1 -2 FQ2: Pass two FASTQ files with reads1, reads2, respectively.
# -h FASTA: human reference.  Required
# -m FASTA: mouse reference.  Required
# -s sample: sample name.  Default is "hgmm"
# -o outdir: output directory.  Default is '.'
# -d: dry run.  Print commands but do not execute them

IMAGE_MGI="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate"

FQ1="/gscuser/mwyczalk/projects/Rabix/MouseTrap2/test-dat/NIX5.10K.R1.fastq.gz"
FQ2="/gscuser/mwyczalk/projects/Rabix/MouseTrap2/test-dat/NIX5.10K.R2.fastq.gz"

HGFA="/gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh37-lite.fa"
MMFA="/gscmnt/gc2737/ding/hsun/data/ensemble_v91/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

OUTDIR="/gscuser/mwyczalk/projects/Rabix/MouseTrap2/results"
mkdir -p $OUTDIR

CMD="/bin/bash MouseTrap2.sh -1 $FQ1 -2 $FQ2 -h $HGFA -m $MMFA -o $OUTDIR"

MEMGB=8
LSF_ARGS="-R \"rusage[mem=${MEMGB}000]\" -M ${MEMGB}000000"

bsub -q research-hpc $LSF_ARGS -Is -a "docker($IMAGE_MGI)" $CMD

