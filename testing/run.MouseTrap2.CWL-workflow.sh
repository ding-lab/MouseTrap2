# Script to demonstrate calling MouseTrap2 workflow from command line

# Data not provided with distribution.  Here, use the same FASTQ data for human and PDX
# TODO: show how test dataset created

# Certain parameters from /diskmnt/Projects/Users/hsun/beta_tinDaisy/tin-daisy/test.C3N-01649/project_config.C3N-01649-test.sh

SAMPLE="NIX5-test"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"


# This is a test database associated with TinDaisy demo dataset
DEMOD="../params"
#DBSNP_DB="test-data/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz"
DBSNP_DB="/diskmnt/Projects/Users/hsun/data/dbsnp/00-All.brief.pass.cosmic.vcf.gz"  # From Hua 
PINDEL_CONFIG="$DEMOD/pindel.WES.ini"
VARSCAN_CONFIG="$DEMOD/varscan.WES.ini"
STRELKA_CONFIG="$DEMOD/strelka.WES.ini"

# reference stuff in /data1, test FASTQs in /data2
#DATA1="/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference"
DATA1="/diskmnt/Projects/Users/mwyczalk/data/docker/data/A_Reference"
DATA2="./test-data"

FQ1="$DATA2/NIX5.10K.R1.fastq.gz"
FQ2="$DATA2/NIX5.10K.R2.fastq.gz"

HGFA="$DATA1/GRCh37-lite.fa"
MMFA="$DATA1/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

VEP_CACHE_GZ="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"
VEP_CACHE_VERSION="90"
ASSEMBLY="GRCh37"

# This is optional; remove this for online VEP db lookups
CACHE="\
--vep_cache_gz $VEP_CACHE_GZ \
--vep_cache_version $VEP_CACHE_VERSION \
--assembly $ASSEMBLY \
"

ARGS="\
--dbsnp_db $DBSNP_DB \
--FQ1 $FQ1 \
--FQ2 $FQ2 \
--FQ1_PDX $FQ1 \
--FQ2_PDX $FQ2 \
--HGFA $HGFA \
--MMFA $MMFA \
--SampleName $SAMPLE \
--pindel_config $PINDEL_CONFIG \
--strelka_config $STRELKA_CONFIG \
--varscan_config $VARSCAN_CONFIG \
--varscan_vcf_filter_config $DEMOD/vcf_filter_config.ini \
--strelka_vcf_filter_config $DEMOD/vcf_filter_config.ini \
--pindel_vcf_filter_config $DEMOD/pindel-vcf_filter_config.ini \
--af_filter_config $DEMOD/af_filter_config.ini \
--classification_filter_config $DEMOD/classification_filter_config.ini \
$CACHE \
"

RABIX="rabix"
CWL="../cwl/mousefilter2-tindaisy-workflow.cwl"
#    --assembly <arg> - GRCh37 or GRCh38
#    --centromere_bed <arg> - optional.  Used for pindel
#    --dbsnp_db <arg> - database used for DBSNP filter
#    --FQ1 <arg> - reads 1, in FASTQ format
#    --FQ1_PDX <arg>
#    --FQ2 <arg> - reads 2, in FASTQ format
#    --FQ2_PDX <arg>
#    --HGFA <arg> - Human reference
#    --is_strelka2 - boolean, optional.  Set to use Strelka2 as variant caller instead of Strelka v1
#    --MMFA <arg> - Mouse reference
#    --no_delete_temp <arg> - if set to 1, keep all intermediate files
#    --output_vep <arg> - if 1, output in VEP instead of VCF format
#    --pindel_config <arg> - PINDEL configuration file
#    --SampleName <arg> - Run identifier
#    --strelka_config <arg> - Strelka configuration file
#    --varscan_config <arg> - Varscan configuration file
#    --vep_cache_gz <arg> - optional path to compressed VEP cache file.  If defined, will not perform online VEP queries
#       vep_cache_gz should be used for significantly improved performance in VEP annotation

$RABIX $RABIX_ARGS $CWL -- $ARGS
