# Script to demonstrate calling MouseTrap2 workflow from command line

source project_config.sh

ARGS="\
--assembly $ASSEMBLY \
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
--varscan_vcf_filter_config $VARSCAN_VCF_FILTER_CONFIG \
--strelka_vcf_filter_config $STRELKA_VCF_FILTER_CONFIG \
--pindel_vcf_filter_config $PINDEL_VCF_FILTER_CONFIG \
--af_filter_config $AF_FILTER_CONFIG \
--classification_filter_config $CLASSIFICATION_FILTER_CONFIG \
"

RABIX="rabix"
CWL="cwl/mousefilter2-tindaisy-workflow.cwl"

$RABIX $RABIX_ARGS $CWL -- $ARGS
