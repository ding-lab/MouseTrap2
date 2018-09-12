SAMPLE="NIX5-test"

# All output will go to OUTDIR
# NOTE: this will generate a lot of intermediate data (>50Gb) for real datasets
# Be sure that OUTD points to a partition which can handle this volume
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"

# This is a test database associated with TinDaisy demo dataset
PARAMS="params"
PINDEL_CONFIG="$PARAMS/pindel.WES.ini"
VARSCAN_CONFIG="$PARAMS/varscan.WES.ini"
STRELKA_CONFIG="$PARAMS/strelka.WES.ini"

VARSCAN_VCF_FILTER_CONFIG="$PARAMS/vcf_filter_config.ini"
STRELKA_VCF_FILTER_CONFIG="$PARAMS/vcf_filter_config.ini"
PINDEL_VCF_FILTER_CONFIG="$PARAMS/pindel-vcf_filter_config.ini"
AF_FILTER_CONFIG="$PARAMS/af_filter_config.ini"
CLASSIFICATION_FILTER_CONFIG="$PARAMS/classification_filter_config.ini"

# reference stuff in /data1, test FASTQs in /data2
#DATA1="/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference"
DATA1="/diskmnt/Projects/Users/mwyczalk/data/docker/data/A_Reference"
DATA2="/diskmnt/Datasets/PDX/TestData/HCI/CGC_import/data"

# TESTING NIX5.10K.  Use same reads for tumor, normal - just for testing
#FQT1="$DATA2/NIX5.10K.R1.fastq.gz"
#FQT2="$DATA2/NIX5.10K.R2.fastq.gz"
#FQN1=$FQT1
#FQN2=$FQT2

FQT1="$DATA2/14311X4_HCI-027_Mix-80Patient-tumor-20mouse_7_1.fastq.gz"
FQT2="$DATA2/14311X4_HCI-027_Mix-80Patient-tumor-20mouse_7_2.fastq.gz"

FQN1="$DATA2/14311X1_HCI-027_Patient-blood-normal_7_1.fastq.gz"
FQN2="$DATA2/14311X1_HCI-027_Patient-blood-normal_7_2.fastq.gz"

HGFA="$DATA1/GRCh37-lite.fa"
MMFA="$DATA1/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

#DBSNP_DB="$DATA2/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz"
DBSNP_DB="/diskmnt/Projects/Users/mwyczalk/data/docker/data/B_Filter/dbsnp.noCOSMIC.GRCh37.vcf.gz"

# if using cache (recommended for production)
VEP_CACHE_GZ="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"
VEP_CACHE_VERSION="90"
ASSEMBLY="GRCh37"
