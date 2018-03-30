RABIX="/Users/mwyczalk/src/rabix-cli-1.0.4/rabix"
CWL="mousetrap2.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"

FQ1="/data2/NIX5.10K.R1.fastq.gz"
FQ2="/data2/NIX5.10K.R2.fastq.gz"

HGFA="/data1/GRCh37-lite.fa"
MMFA="/data1/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

$RABIX $RABIX_ARGS $CWL -- --FQ1 $FQ1 --FQ2 $FQ2 --HGFA $HGFA --MMFA $MMFA
