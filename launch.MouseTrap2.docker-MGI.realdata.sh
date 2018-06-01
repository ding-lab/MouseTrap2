# Launch docker container and run MouseTrap2.  Specific to MGI
# This uses a BAM as a starting point

# Arguments
# -b BAM: Pass BAM to be processed
# -1 FQ1 -2 FQ2: Pass two FASTQ files with reads1, reads2, respectively.
# -h FASTA: human reference.  Required
# -m FASTA: mouse reference.  Required
# -s sample: sample name.  Default is "hgmm"
# -o outdir: output directory.  Default is '.'
# -d: dry run.  Print commands but do not execute them

IMAGE_MGI="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate"

#FQ1="/gscuser/mwyczalk/projects/Rabix/MouseTrap2/test-dat/NIX5.10K.R1.fastq.gz"
#FQ2="/gscuser/mwyczalk/projects/Rabix/MouseTrap2/test-dat/NIX5.10K.R2.fastq.gz"
WHIMBAM="/gscmnt/gc2612/whim_pdx_hamlet_xenograft/model_data/f8cc6fae4e784e41864b680d679246f8/build2ac9536b9e6b43f3a568baffb5974d40/alignments/94bf7538283c4e06b7e789b1d0eb848b.bam"

HGFA="/gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh37-lite.fa"
MMFA="/gscmnt/gc2737/ding/hsun/data/ensemble_v91/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

OUTDIR="/gscuser/mwyczalk/projects/Rabix/MouseTrap2/results"
mkdir -p $OUTDIR
LOGS="-e $OUTDIR/run.err -o $OUTDIR/run.out"

#CMD="/bin/bash MouseTrap2.sh -1 $FQ1 -2 $FQ2 -h $HGFA -m $MMFA -o $OUTDIR"
CMD="/bin/bash MouseTrap2.sh -b $WHIMBAM -h $HGFA -m $MMFA -o $OUTDIR"

MEMGB=8
LSF_ARGS="-R \"rusage[mem=${MEMGB}000]\" -M ${MEMGB}000000"

bsub $LOGS -q research-hpc $LSF_ARGS -a "docker($IMAGE_MGI)" $CMD

