# Run MouseTrap2 from within docker environment

# Arguments
# -b BAM: Pass BAM to be processed
# -1 FQ1 -2 FQ2: Pass two FASTQ files with reads1, reads2, respectively.
# -h FASTA: human reference.  Required
# -m FASTA: mouse reference.  Required
# -s sample: sample name.  Default is "hgmm"
# -o outdir: output directory.  Default is '.'
# -d: dry run.  Print commands but do not execute them

FQ1="/data2/NIX5.10K.R1.fastq.gz"
FQ2="/data2/NIX5.10K.R2.fastq.gz"

HGFA="/data1/GRCh37-lite.fa"
MMFA="/data1/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

OUTDIR="./results"
mkdir -p $OUTDIR

bash MouseTrap2.sh -1 $FQ1 -2 $FQ2 -h $HGFA -m $MMFA -o $OUTDIR