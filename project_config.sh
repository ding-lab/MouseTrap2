SAMPLE="NIX5-test"

# try to have all output go to output_dir
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
DATA1="/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference"
DATA2="./testing/test-data"

FQ1="$DATA2/NIX5.10K.R1.fastq.gz"
FQ2="$DATA2/NIX5.10K.R2.fastq.gz"

HGFA="$DATA1/GRCh37-lite.fa"
MMFA="$DATA1/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa"

DBSNP_DB="$DATA2/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz"

# if using cache (recommended for production)
VEP_CACHE_GZ="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"
VEP_CACHE_VERSION="90"
ASSEMBLY="GRCh37"
