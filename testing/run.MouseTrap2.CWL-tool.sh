RABIX="rabix"
CWL="../cwl/mousetrap2.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"

# reference stuff in /data1
DATA1="/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference"
# test FASTQs in /data2
DATA2="/Users/mwyczalk/Projects/Rabix/MouseTrap2/test-dat"

FQ1="$DATA2/NIX5.10K.R1.fastq.gz"
FQ2="$DATA2/NIX5.10K.R2.fastq.gz"

HGFA="$DATA1/GRCh37-lite.fa"
MMFA="$DATA1/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

SAMPLE="NIX5-test"

$RABIX $RABIX_ARGS $CWL -- --FQ1 $FQ1 --FQ2 $FQ2 --HGFA $HGFA --MMFA $MMFA --SAMPLE $SAMPLE
