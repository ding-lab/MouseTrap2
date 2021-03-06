# Script to demonstrate calling MouseTrap2 workflow from command line

source project_config.sh

# This is optional; remove this for online VEP db lookups
CACHE="\
--vep_cache_gz $VEP_CACHE_GZ \
--vep_cache_version $VEP_CACHE_VERSION \
--assembly $ASSEMBLY \
"

ARGS="\
--dbsnp_db $DBSNP_DB \
--FQ1 $FQN1 \
--FQ2 $FQN2 \
--FQ1_PDX $FQT1 \
--FQ2_PDX $FQT2 \
--HGFA $HGFA \
--MMFA $MMFA \
--SampleName $SAMPLE \
--pindel_config $PINDEL_CONFIG \
--strelka_config $STRELKA_CONFIG \
--varscan_config $VARSCAN_CONFIG \
--varscan_vcf_filter_config $VARSCAN_VCF_FILTER_CONFIG \
--strelka_vcf_filter_config $STRELKA_VCF_FILTER_CONFIG \
--pindel_vcf_filter_config $PINDEL_VCF_FILTER_CONFIG \
--af_filter_config $AF_FILTER_CONFIG \
--classification_filter_config $CLASSIFICATION_FILTER_CONFIG \
"
# $CACHE \

RABIX="rabix"
CWL="cwl/MouseTrap2.workflow.cwl"

$RABIX $RABIX_ARGS $CWL -- $ARGS
