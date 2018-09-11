# Run MouseTrap2 filter on BAM / FASTQ files.  Removes mouse reads and returns human-only BAM
# Usage:
# MouseTrap2.sh [arguments] 
#
# MouseTrap2.sh will process either one BAM file or two FASTQ files; require either a BAM (-b)
# or two FASTQs (-1, -2) to be passed.
# Output:
#       OUTD/SAMPLE.disambiguate_human.bam
#       OUTD/SAMPLE.disambiguate_human.bam.bai
#
# Arguments:
# -b BAM: Pass BAM to be processed
# -1 FQ1 -2 FQ2: Pass two FASTQ files with reads1, reads2, respectively.
# -r FASTA: reference to align FASTQ; after alignment complete, quit.
#     name is $OUTD/SAMPLE.bam
# -h FASTA: human reference.  Required (unless -r)
# -m FASTA: mouse reference.  Required (unless -r)
# -s sample: sample name.  Default is "hgmm"
# -o outdir: output directory.  Default is '.'
# -c: clean.  Remove temporary files after execution
# -G: no optimize.  Use step-by-step processing instead of pipelines in `bwa mem` steps


# SAMPLE is used extensively for filenames and BAM header
SAMPLE="hgmm" # name of sample, arbitrary name
OUTD="."  # output
TMPLIST=""  # keep track of generated files, to be optionally deleted at the end
OPTIMIZE=1

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

# Test whether REF is a file and exists.  It is identified as "$REFTYPE Reference" in error messages
function checkREF {
    REF=$1
    REFTYPE=$2  
    if [ -z $REF ]; then
        >&2 echo Error: $REFTYPE Reference not defined
        exit 1
    fi
    if [ ! -e $REF ]; then
        >&2 echo Error: $REFTYPE does not exist: $REF
        exit 1
    fi
}


# Convert BAM to two sorted FASTQ files
# Usage: bam2fq BAM FQ1 FQ2
function bam2fq {
    MYBAM=$1 # input
    MYFQ1=$2 # output
    MYFQ2=$3 # output

    >&2 echo Sorting $MYBAM, extracting FASTQs to $MYFQ1 and $MYFQ2 ...
    >&2 echo    tmp: $OUTD/bam2fq-tmp
#  no pipes equivalent
#    $SAMTOOLS sort -m 1G -@ 6 -o $OUTD/$SAMPLE.sortbyname.bam -n $MYBAM
#    $SAMTOOLS fastq $OUTD/$SAMPLE.sortbyname.bam -1 $MYFQ1 -2 $MYFQ2

    $SAMTOOLS sort -m 1G -@ 6 -n $MYBAM -T $OUTD/bam2fq-tmp | $SAMTOOLS fastq -1 $MYFQ1 -2 $MYFQ2 -
    test_exit_status
    >&2 echo Done sorting.
}


# bwa human align and sort
# This requires > 5Gb memory
function alignReadsSamtools {
    FQ1_S=$1
    FQ2_S=$2
    REFFA_S=$3
    BAMOUT_S=$4  # this path is independent of $OUTD
    OUTD_S=$5    # Intermediate stuff here
    OPTIMIZE_S=$6

    >&2 echo TESTING alignReadsSamtools
    >&2 echo FQ1_S $FQ1_S
    >&2 echo FQ2_S $FQ2_S
    >&2 echo REFFA_S $REFFA_S
    >&2 echo BAMOUT_S $BAMOUT_S
    >&2 echo OUTD_S $OUTD_S
    >&2 echo OPTIMIZE_S $OPTIMIZE_S

    # Header applied during alignment
    BWAR="@RG\tID:$SAMPLE\tSM:$SAMPLE\tPL:illumina\tLB:$SAMPLE.lib\tPU:$SAMPLE.unit"
    TMPLIST="$TMPLIST $HGOUT"


    if [ $OPTIMIZE_S == 1 ]; then
        >&2 echo Running optimized pipeline \`bwa mem \| samtools view \| samtools sort\`
    # This is the original piped version.  Note failure may be due to memory requirements (>8Gb needed, 16Gb tested OK)
        $BWA mem -t 8 -M -R "$BWAR" $REFFA_S $FQ1_S $FQ2_S | $SAMTOOLS view -Sbh - | $SAMTOOLS sort -m 1G -@ 6 -o $BAMOUT_S -n -T $OUTD_S/tmpaln -
    else
        ### Breaking up into individual steps for testing
        BWAOUT="$OUTD_S/BWA.out"
        VIEWOUT="$OUTD_S/VIEW.out"
        TMPLIST="$TMPLIST $BWAOUT $VIEWOUT"
        >&2 echo running bwa mem step by step.  Output to $BWAOUT
        $BWA mem -t 8 -M -R "$BWAR" $REFFA_S $FQ1_S $FQ2_S  > $BWAOUT
        test_exit_status

        >&2 echo running samtools view  Output to $VIEWOUT
        $SAMTOOLS view -Sbh $BWAOUT > $VIEWOUT
        test_exit_status
        >&2 echo running samtools sort  Output to $BAMOUT_S

        # below, fails with 8Gb, succeeds with 16Gb
        $SAMTOOLS sort -m 1G -@ 6 -o $BAMOUT_S -n -T $OUTD/tmpaln $VIEWOUT
        test_exit_status
    fi
}

function alignReadsPicard {
    FQ1_P=$1
    FQ2_P=$2
    REFFA_P=$3
    BAMOUT_P=$4  # this path is independent of $OUTD
    OUTD_P=$5    # Intermediate stuff here.  
    OPTIMIZE_P=$6

    >&2 echo TESTING alignReadsPicard
    >&2 echo FQ1_P $FQ1_P
    >&2 echo FQ2_P $FQ2_P
    >&2 echo REFFA_P $REFFA_P
    >&2 echo BAMOUT_P $BAMOUT_P
    >&2 echo OUTD_P $OUTD_P
    >&2 echo OPTIMIZE_P $OPTIMIZE_P

    BWAR="@RG\tID:$SAMPLE\tSM:$SAMPLE\tPL:illumina\tLB:$SAMPLE.lib\tPU:$SAMPLE.unit"

    if [ $OPTIMIZE_P == 1 ]; then

        >&2 echo Starting BWA mem + SortSam optimization, then MarkDuplicates 
        SORTSAM="$OUTD_P/$SAMPLE.SortSam.out"
        TMPLIST="$TMPLIST $SORTSAM"

        # BWA -> SortSam is piped, SortSam -> Mark written to file
        # From http://broadinstitute.github.io/picard/faq.html
        # for pipes: /dev/stdin
        # MarkDuplicates cannot read input from STDIN

        >&2 echo Running BWA mem + SortSam 
        $BWA mem -t 8 -M -R "$BWAR" $REFFA_P $FQ1_P $FQ2_P | \
        $JAVA -Xmx8G -jar $PICARD_JAR SortSam I=/dev/stdin O=$SORTSAM SORT_ORDER=coordinate 
        test_exit_status

        >&2 echo Running MarkDuplicates 
        $JAVA -Xmx8G -jar $PICARD_JAR MarkDuplicates I=$SORTSAM O=$BAMOUT_P  REMOVE_DUPLICATES=true  M=$OUTD_P/picard.remdup.metrics.txt ; test_exit_status

    else

        >&2 echo Starting BWA mem + SortSam + MarkDuplicates step by step
        BWAOUT="$OUTD_P/$SAMPLE.BWA.out"
        SORTSAM="$OUTD_P/$SAMPLE.SortSam.out"
        TMPLIST="$TMPLIST $BWAOUT $SORTSAM"

        >&2 echo running BWA mem, output to temp file $BWAOUT
        $BWA mem -t 8 -M -R "$BWAR" $REFFA_P $FQ1_P $FQ2_P  > $BWAOUT ; test_exit_status

        >&2 echo running picard SortSam, output to temp file $SORTSAM
        $JAVA -Xmx8G -jar $PICARD_JAR SortSam I=$BWAOUT O=$SORTSAM SORT_ORDER=coordinate ; test_exit_status

        >&2 echo running picard MarkDuplicates, output to final file $OUTFINAL
        $JAVA -Xmx8G -jar $PICARD_JAR MarkDuplicates I=$SORTSAM O=$BAMOUT_P  REMOVE_DUPLICATES=true  M=$OUTD_P/picard.remdup.metrics.txt ; test_exit_status
    fi
}

# OPTIMIZE flag is used in alignReadsSamtools and alignReadsPicard (both  `bwa mem` steps) to implement `pipe` optimization
# of the sort, `bwa mem | samtools view | samtools sort` and `bwa mem | picard SortSam`

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":b:1:2:h:m:s:r:o:cG" opt; do
  case $opt in
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
    r) 
      REFFA=$OPTARG
      ATQ=1 # align then quit
      echo "Setting Reference $REFFA" >&2
      echo "Quitting after alignment" >&2
      ;;
    s) 
      SAMPLE=$OPTARG
      echo "Setting sample name $SAMPLE" >&2
      ;;
    o) 
      OUTD=$OPTARG
      echo "Setting output directory $OUTD" >&2
      ;;
    c) 
      CLEAN=1
      echo "Removing temporary files when complete" >&2
      ;;
    G) 
      OPTIMIZE=0
      echo "Running pipelines step-by-step (no optimize)" >&2
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

# ATQ is Align then Quit, using one provided reference
if [ -z $ATQ ]; then
    checkREF $HGFA "Human"
    checkREF $MMFA "Mouse"
else
    checkREF $REFFA "Provided"
fi

>&2 echo MouseTrap2 starting...

# Create output diretory and make sure it succeeded
mkdir -p $OUTD
test_exit_status

if [ ! -z $BAM ]; then
    >&2 echo Converting BAM to input FASTQ
    FQ1=$OUTD/$SAMPLE\_1.fastq.gz
    FQ2=$OUTD/$SAMPLE\_2.fastq.gz
    bam2fq $BAM $FQ1 $FQ2
    TMPLIST="$TMPLIST $FQ1 $FQ2"
else
    >&2 echo Input FASTQ provided
fi

if [ ! -z $ATQ  ]; then

    >&2 echo Aligning reads to provided reference...
    OUT="$OUTD/$SAMPLE.bam"
    TMPLIST="$TMPLIST $HGOUT"
    #alignReadsSamtools $FQ1 $FQ2 $REFFA $OUT $OUTD $OPTIMIZE
    # Above does not seem to preserve all headers.  Using alignReadsPicard instead... 
    alignReadsPicard $FQ1 $FQ2 $REFFA $OUT $OUTD $OPTIMIZE
    >&2 echo Indexing $OUT
    $SAMTOOLS index $OUT
    test_exit_status
    >&2 echo Quitting after alignment.  Written to $OUT
    exit 0

fi


>&2 echo Aligning reads to human reference...
HGOUT="$OUTD/human.sort.bam"
TMPLIST="$TMPLIST $HGOUT"
alignReadsSamtools $FQ1 $FQ2 $HGFA $HGOUT $OUTD $OPTIMIZE

# bwa mouse align and sort.  Optimized pipeline in all cases
>&2 echo Aligning reads to mouse reference...
MMOUT="$OUTD/mouse.sort.bam"
TMPLIST="$TMPLIST $MMOUT"
alignReadsSamtools $FQ1 $FQ2 $MMFA $MMOUT $OUTD $OPTIMIZE

# mouse-filter - Disambiguate
>&2 echo Running Disambiguate...
$DISAMBIGUATE -s $SAMPLE -o $OUTD -a bwa $HGOUT $MMOUT
# This writes $OUTD/$SAMPLE.disambiguatedSpeciesA.bam (used later) as well as the following:
TMPLIST="$TMPLIST \
$OUTD/$SAMPLE.disambiguatedSpeciesA.bam \
$OUTD/$SAMPLE.disambiguatedSpeciesB.bam \
$OUTD/$SAMPLE.ambiguousSpeciesA.bam \
$OUTD/$SAMPLE.ambiguousSpeciesB.bam"
test_exit_status

# Keeping only species A reads (human)
FQA1="$OUTD/$SAMPLE.disam_1.human.fastq.gz"
FQA2="$OUTD/$SAMPLE.disam_2.human.fastq.gz"
bam2fq $OUTD/$SAMPLE.disambiguatedSpeciesA.bam $FQA1 $FQA2
TMPLIST="$TMPLIST $FQA1 $FQA2"

OUTFINAL="$OUTD/$SAMPLE.disambiguate_human.bam"

alignReadsPicard $FQA1 $FQA2 $HGFA $OUTFINAL $OUTD $OPTIMIZE

# index bam
>&2 echo Indexing $OUTFINAL
$SAMTOOLS index $OUTFINAL
test_exit_status

if [ ! -z $CLEAN ]; then
    >&2 echo Removing temporary files: $TMPLIST
    rm -f $TMPLIST
fi

>&2 echo MouseTrap2 processing complete.  Results written to $OUTFINAL
exit 0
