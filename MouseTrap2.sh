# Run MouseTrap2 filter on BAM / FASTQ files
# Usage:
# MouseTrap2.sh [arguments] 
#
# MouseTrap2.sh will process either one BAM file or two FASTQ files; require either a BAM (-b)
# or two FASTQs (-1, -2) to be passed.
#
#
# Arguments:
# -b BAM: Pass BAM to be processed
# -1 FQ1 -2 FQ2: Pass two FASTQ files with reads1, reads2, respectively.
# -h FASTA: human reference.  Required
# -m FASTA: mouse reference.  Required
# -s sample: sample name.  Default is "hgmm"
# -o outdir: output directory.  Default is '.'
# -d: dry run.  Print commands but do not execute them

# Output
# $OUTD/$SAMPLE.mouseFiltered.remDup.bam
# $OUTD/$SAMPLE.mouseFiltered.remDup.bam.bai

# sample data
# HGFA="/gscmnt/gc2737/ding/hsun/data/GRCh37-lite/GRCh37-lite.fa"
# MMFA="/gscmnt/gc2737/ding/hsun/data/ensemble_v91/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

# Default values
SAMPLE="hgmm" # name of sample, arbitrary name
OUTD="."  # output

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":b:1:2:h:m:s:o:" opt; do
  case $opt in
    d)  
      echo "Dry run" >&2
      DRYRUN=1
      ;;
    b) 
      BAM=$OPTARG
      echo "Setting BAM file $BAM" >&2
      ;;
    1) 
      FQ1=$OPTARG
      echo "Setting FASTQ1 $FQ1" >&2
      ;;
    2) 
      FQ2=$OPTARG
      echo "Setting FASTQ2 $FQ2" >&2
      ;;
    h) 
      HGFA=$OPTARG
      echo "Setting Human reference $HGFA" >&2
      ;;
    m) 
      MMFA=$OPTARG
      echo "Setting Mouse reference $MMFA" >&2
      ;;
    s) 
      SAMPLE=$OPTARG
      echo "Setting sample name $SAMPLE" >&2
      ;;
    o) 
      OUTD=$OPTARG
      echo "Setting output directory $OUTD" >&2
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

#if [ "$#" -ne 1 ]; then
#    >&2 echo Error: Wrong number of arguments
#    exit
#fi

# The following based on docker image
JAVA="/usr/bin/java"
PICARD_JAR="/opt/conda/share/picard-2.17.11-0/picard.jar"
BWA="/opt/conda/bin/bwa"
SAMTOOLS="/opt/conda/bin/samtools"
DISAMBIGUATE="/opt/conda/bin/ngs_disambiguate"

# Make sure have either a BAM file, or two FASTQs
if [ ! -z $BAM ]; then  # BAM is defined.  Make sure FASTQs are not
    if [ ! -z $FQ1 ] || [ ! -z $FQ2 ]; then
        >&2 echo Error: Both BAM and FASTQs defined
        exit 1
    fi
    if [ ! -e $BAM ]; then
        >&2 echo Error: BAM file does not exist: $BAM
        exit 1
    fi
else
# BAM not defined. Make sure both FQ1 and FQ2 are set and exist
    if [ -z $FQ1 ]; then
        >&2 echo Error: FQ1 \(-1\) not defined
        exit 1
    fi
    if [ ! -e $FQ1 ]; then
        >&2 echo Error: FQ1 file does not exist: $FQ1
        exit 1
    fi
    if [ -z $FQ2 ]; then
        >&2 echo Error: FQ2 \(-2\) not defined
        exit 1
    fi
    if [ ! -e $FQ2 ]; then
        >&2 echo Error: FQ2 file does not exist: $FQ2
        exit 1
    fi
fi

# Make sure mouse and human references are defined and exist
if [ -z $HGFA ]; then
    >&2 echo Error: Human reference \(-h\) not defined
    exit 1
fi
if [ ! -e $HGFA ]; then
    >&2 echo Error: Human reference does not exist: $HGFA
    exit 1
fi
if [ -z $MMFA ]; then
    >&2 echo Error: Mouse reference \(-m\) not defined
    exit 1
fi
if [ ! -e $MMFA ]; then
    >&2 echo Error: Human reference does not exist: $MMFA
    exit 1
fi

function test_exit_status {
	# Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    # exit code 137 is fatal error signal 9: http://tldp.org/LDP/abs/html/exitcodes.html

	rcs=${PIPESTATUS[*]}; 
    for rc in ${rcs}; do 
        if [[ $rc != 0 ]]; then 
            >&2 echo Fatal error.  Exiting 
            exit $rc; 
        fi; 
    done
}

# Usage: bam2fq BAM FQ1 FQ2
function bam2fq {
    MYBAM=$1
    MYFQ1=$2
    MYFQ2=$2

    >&2 echo Sorting $MYBAM, extracting FASTQs to $MYFQ1 and $MYFQ2 ...
# V1 no pipes
#    $SAMTOOLS sort -m 1G -@ 6 -o $OUTD/$SAMPLE.sortbyname.bam -n $MYBAM
#    $SAMTOOLS fastq $OUTD/$SAMPLE.sortbyname.bam -1 $MYFQ1 -2 $MYFQ2

    $SAMTOOLS sort -m 1G -@ 6 -n $MYBAM | $SAMTOOLS fastq -1 $MYFQ1 -2 $MYFQ2 -
    >&2 echo Done sorting.
}

if [ ! -z $BAM ]; then
    $FQ1=$OUTD/$SAMPLE\_1.fastq.gz
    $FQ2=$OUTD/$SAMPLE\_2.fastq.gz
    bam2fq $BAM $FQ1 $FQ2
fi

BWAR="@RG\tID:$SAMPLE\tSM:$SAMPLE\tPL:illumina\tLB:$SAMPLE.lib\tPU:$SAMPLE.unit"

# bwa human align and sort
# This requires > 5Gb memory
>&2 echo Aligning reads to human reference...
HGOUT="$OUTD/human.sort.bam"
$BWA mem -t 4 -M -R $BWAR $HGFA $FQ1 $FQ2 | $SAMTOOLS view -Sbh - | $SAMTOOLS sort -m 1G -@ 6 -o $HGOUT -n -T $OUTD/human -
test_exit_status

# bwa mouse align and sort
>&2 echo Aligning reads to mouse reference...
MMOUT="$OUTD/mouse.sort.bam"
$BWA mem -t 4 -M -R $BWAR $MMFA $FQ1 $FQ2 | $SAMTOOLS view -Sbh - | $SAMTOOLS sort -m 1G -@ 6 -o $MMOUT -n -T $OUTD/mouse -
test_exit_status

# sort bam by natural name
#$SAMTOOLS sort -m 1G -@ 6 -o $OUTD/human.sort.bam -n -T $OUTD/human $OUTD/human.bam
#$SAMTOOLS sort -m 1G -@ 6 -o $OUTD/mouse.sort.bam -n -T $OUTD/mouse $OUTD/mouse.bam

# mouse-filter - Disambiguate
>&2 echo Running Disambiguate...
$DISAMBIGUATE -s $SAMPLE -o $OUTD -a bwa $HGOUT $MMOUT
test_exit_status

# retain only "read mapped in proper pair" 
>&2 echo Retaining mapped reads, and sorting
$SAMTOOLS view -b -f 0x2 $OUTD/$SAMPLE.disambiguatedSpeciesA.bam | $SAMTOOLS sort -m 1G -@ 6 -o $OUTD/$SAMPLE.mouseFiltered.bam -T $OUTD/$SAMPLE.mouseFiltered -
test_exit_status

# remove-duplication
>&2 echo Running Picard MarkDuplicates
OUTFINAL=$OUTD/$SAMPLE.mouseFiltered.remDup.bam
$JAVA -Xmx8G -jar $PICARD_JAR MarkDuplicates \
   I=$OUTD/$SAMPLE.mouseFiltered.bam \
   O=$OUTFINAL \
   REMOVE_DUPLICATES=true \
   M=$OUTD/picard.remdup.metrics.txt
test_exit_status

# index bam
>&2 echo Indexing $OUTFINAL
$SAMTOOLS index $OUTD/$SAMPLE.mouseFiltered.remDup.bam
test_exit_status

>&2 echo MouseTrap2 processing complete
