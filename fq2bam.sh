# Simple script to align (`bwa mem`) two FASTQ files to generate a BAM
# Usage:
# fq2bam.sh [options] FASTQ1 FASTQ2
#
# Align FASTQ1 and FASTQ2 using bwa mem to generate a BAM file.
# Result is sorted and indexed.
# 
# Procedure based on that in MouseFilter2.sh
#
# Output:
#       OUTD/SAMPLE.disambiguate_human.bam
#       OUTD/SAMPLE.disambiguate_human.bam.bai
#
# Arguments:
# -r FASTA: reference.  Required
# -s sample: sample name.  Default is "sample"
# -O outbam: output BAM.  outbam.bai will also be written.  Default is out.bam
# -c: clean.  Remove temporary files after execution

# SAMPLE is used extensively for filenames and BAM header
SAMPLE="hgmm" # name of sample, arbitrary name
OUTBAM="out.bam" # name of sample, arbitrary name
TMPLIST=""  # keep track of generated files, to be optionally deleted at the end

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":r:s:O:c" opt; do
  case $opt in
    r) 
      REFFA=$OPTARG
      echo "Setting reference $REFFA" >&2
      ;;
    s) 
      SAMPLE=$OPTARG
      echo "Setting sample name $SAMPLE" >&2
      ;;
    O) 
      OUTBAM=$OPTARG
      echo "Setting output BAM $OUTBAM" >&2
      ;;
    c) 
      CLEAN=1
      echo "Removing temporary files when complete" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ "$#" -ne 2 ]; then
    >&2 echo Error: Wrong number of arguments.  FASTA1 and FASTA2 required
    exit
fi
FQ1=$1
FQ2=$2
>&2 echo Input FASTA: 
>&2 echo $FQ1 
>&2 echo $FQ2 

# The following based on docker image
BWA="/opt/conda/bin/bwa"
SAMTOOLS="/opt/conda/bin/samtools"

if [ ! -e $FQ1 ]; then
    >&2 echo Error: FASTQ1 file does not exist: $FQ1
    exit 1
fi
if [ ! -e $FQ2 ]; then
    >&2 echo Error: FASTQ2 file does not exist: $FQ2
    exit 1
fi

# Make sure mouse and human references are defined and exist
if [ -z $REFFA ]; then
    >&2 echo Error: Reference \(-r\) not defined
    exit 1
fi
if [ ! -e $REFFA ]; then
    >&2 echo Error: Reference does not exist: $REFFA
    exit 1
fi


function test_exit_status {
	# Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    # exit code 137 is fatal error signal 9: http://tldp.org/LDP/abs/html/exitcodes.html
    #   (sometimes seen when process exits from lack of memory)

	rcs=${PIPESTATUS[*]}; 
    for rc in ${rcs}; do 
        if [[ $rc != 0 ]]; then 
            >&2 echo Fatal error.  Exiting 
            exit $rc; 
        fi; 
    done
}

>&2 echo fq2bam starting...

# Create output diretory and make sure it succeeded
OUTD=$(dirname $OUTBAM)
>&2 echo BAM and temp output directory : $OUTD
mkdir -p $OUTD
test_exit_status

# This taken from MouseTrap2.sh
BWAR="@RG\tID:$SAMPLE\tSM:$SAMPLE\tPL:illumina\tLB:$SAMPLE.lib\tPU:$SAMPLE.unit"

# bwa human align and sort
# This requires > 5Gb memory
>&2 echo Aligning reads to reference...
TMPLIST="$TMPLIST $HGOUT"


# Align and sort FASTQs.  Note failure may be due to memory requirements (>8Gb needed, 16Gb tested OK)
$BWA mem -t 4 -M -R $BWAR $REFFA $FQ1 $FQ2 | $SAMTOOLS view -Sbh - | $SAMTOOLS sort -m 1G -@ 6 -o $OUTBAM -n -T $OUTD/fq2bam -

>&2 echo fq2bam.sh processing complete.  Results written to $OUTBAM
