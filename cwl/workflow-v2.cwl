class: Workflow
cwlVersion: v1.0
id: workflow_v1_1
doc: Washington University Mouse Filter and Somatic Caller toolset
label: workflow-v2
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: strelka_config
    type: File
    'sbg:x': 0
    'sbg:y': 269.375
  - id: reference_fasta
    type: File
    'sbg:x': -11.00200366973877
    'sbg:y': -161.08416748046875
  - id: varscan_config
    type: File
    'sbg:x': 0
    'sbg:y': 162.640625
  - id: pindel_config
    type: File
    'sbg:x': 601.9911499023438
    'sbg:y': 425.046875
  - id: dbsnp_db
    type: File
    'sbg:x': 601.9911499023438
    'sbg:y': 531.75
  - id: assembly
    type: string
    'sbg:exposed': true
  - id: output_vep
    type: string?
    'sbg:exposed': true
  - id: centromere_bed
    type: File?
    'sbg:x': 1.0260521173477173
    'sbg:y': -41.006011962890625
  - id: no_delete_temp
    type: int?
    'sbg:exposed': true
  - id: vep_cache_gz
    type: File?
    'sbg:x': 1220.179443359375
    'sbg:y': 33.649574279785156
  - id: vep_cache_version
    type: string?
    'sbg:exposed': true
  - id: MMFA
    type: File
    'sbg:x': 3.006016731262207
    'sbg:y': 400.80963134765625
  - id: input_pair
    type: 'File[]'
    'sbg:x': -735.3251953125
    'sbg:y': 662.1138305664062
  - id: sample
    type: string?
    'sbg:exposed': true
outputs:
  - id: output_dat
    outputSource:
      - annotate_vep/output_dat
    type: File
    'sbg:x': 1797.252197265625
    'sbg:y': 276.375
steps:
  - id: s1_run_strelka
    in:
      - id: tumor_bam
        source: mousetrap2/disambiguate_human
      - id: normal_bam
        source: fq2bam/output
      - id: reference_fasta
        source: reference_fasta
      - id: strelka_config
        source: strelka_config
    out:
      - id: snvs_passed
    run: s1_run_strelka.cwl
    label: S1_run_strelka
    'sbg:x': 601.9911499023438
    'sbg:y': 297.34375
  - id: s2_run_varscan
    in:
      - id: tumor_bam
        source: mousetrap2/disambiguate_human
      - id: normal_bam
        source: fq2bam/output
      - id: reference_fasta
        source: reference_fasta
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_indel_raw
      - id: varscan_snv_raw
    run: s2_run_varscan.cwl
    label: s2_run_varscan
    'sbg:x': 601.9911499023438
    'sbg:y': 148.671875
  - id: s3_parse_strelka
    in:
      - id: strelka_snv_raw
        source: s1_run_strelka/snvs_passed
      - id: dbsnp_db
        source: dbsnp_db
    out:
      - id: strelka_snv_dbsnp
    run: s3_parse_strelka.cwl
    label: s3_parse_strelka
    'sbg:x': 910.3685913085938
    'sbg:y': 397.046875
  - id: s4_parse_varscan
    in:
      - id: varscan_indel_raw
        source: s2_run_varscan/varscan_indel_raw
      - id: varscan_snv_raw
        source: s2_run_varscan/varscan_snv_raw
      - id: dbsnp_db
        source: dbsnp_db
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_snv_dbsnp
      - id: varscan_indel_dbsnp
    run: s4_parse_varscan.cwl
    label: s4_parse_varscan
    'sbg:x': 910.3685913085938
    'sbg:y': 269.375
  - id: s5_run_pindel
    in:
      - id: tumor_bam
        source: mousetrap2/disambiguate_human
      - id: normal_bam
        source: fq2bam/output
      - id: reference_fasta
        source: reference_fasta
      - id: centromere_bed
        source: centromere_bed
      - id: no_delete_temp
        source: no_delete_temp
    out:
      - id: pindel_raw
    run: s5_run_pindel.cwl
    label: s5_run_pindel
    'sbg:x': 601.9911499023438
    'sbg:y': 0
  - id: s7_parse_pindel
    in:
      - id: pindel_raw
        source: s5_run_pindel/pindel_raw
      - id: reference_fasta
        source: reference_fasta
      - id: pindel_config
        source: pindel_config
      - id: dbsnp_db
        source: dbsnp_db
    out:
      - id: pindel_dbsnp
    run: s7_parse_pindel.cwl
    label: s7_parse_pindel
    'sbg:x': 910.3685913085938
    'sbg:y': 127.703125
  - id: s8_merge_vcf
    in:
      - id: strelka_snv_vcf
        source: s3_parse_strelka/strelka_snv_dbsnp
      - id: varscan_indel_vcf
        source: s4_parse_varscan/varscan_indel_dbsnp
      - id: varscan_snv_vcf
        source: s4_parse_varscan/varscan_snv_dbsnp
      - id: pindel_vcf
        source: s7_parse_pindel/pindel_dbsnp
      - id: reference_fasta
        source: reference_fasta
    out:
      - id: merged_vcf
    run: s8_merge_vcf.cwl
    label: s8_merge_vcf
    'sbg:x': 1236.3226318359375
    'sbg:y': 248.34375
  - id: annotate_vep
    in:
      - id: input_vcf
        source: s8_merge_vcf/merged_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: output_vep
        source: output_vep
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: vep_cache_version
        source: vep_cache_version
    out:
      - id: output_dat
    run: s10_annotate_vep.cwl
    label: annotate_vep
    'sbg:x': 1536.1785888671875
    'sbg:y': 262.375
  - id: mousetrap2
    in:
      - id: FQ1
        source:
          - sbg_split_pair_by_metadata_v2/output_files_1
      - id: FQ2
        source:
          - sbg_split_pair_by_metadata_v2/output_files_2
      - id: HGFA
        source: reference_fasta
      - id: MMFA
        source: MMFA
    out:
      - id: disambiguate_human
    run: ./mousetrap2.cwl
    label: MouseTrap2
    'sbg:x': 226.0108642578125
    'sbg:y': 329.7109375
  - id: sbg_split_pair_by_metadata_v1
    in:
      - id: input_pair
        source:
          - input_pair
      - id: metadata_criteria
        default:
          output_1: 'sample_type:normal'
          output_2: 'sample_type:tumor'
    out:
      - id: output_files_1
      - id: output_files_2
    run: ../../SplitPairByMetadata/sbg-split-pair-by-metadata-v1.cwl
    label: SBG Split Pair by Metadata CWL
    'sbg:x': -450.1869812011719
    'sbg:y': 661.1138305664062
  - id: fq2bam
    in:
      - id: FQ1
        source:
          - sbg_split_pair_by_metadata_v3/output_files_1
      - id: FQ2
        source:
          - sbg_split_pair_by_metadata_v3/output_files_2
      - id: reference
        source: reference_fasta
      - id: sample
        source: sample
    out:
      - id: output
    run: ./fq2bam.cwl
    label: fq2bam
    'sbg:x': 254.37176513671875
    'sbg:y': 776.1077270507812
  - id: sbg_split_pair_by_metadata_v2
    in:
      - id: input_pair
        source:
          - sbg_split_pair_by_metadata_v1/output_files_2
      - id: metadata_criteria
        default:
          output_1: 'paired_end:1'
          output_2: 'paired_end:2'
    out:
      - id: output_files_1
      - id: output_files_2
    run: ../../SplitPairByMetadata/sbg-split-pair-by-metadata-v1.cwl
    label: SBG Split Pair by Metadata CWL
    'sbg:x': -141.9503936767578
    'sbg:y': 650.610595703125
  - id: sbg_split_pair_by_metadata_v3
    in:
      - id: input_pair
        source:
          - sbg_split_pair_by_metadata_v1/output_files_1
      - id: metadata_criteria
        default:
          output_1: 'paired_end:1'
          output_2: 'paired_end:2'
    out:
      - id: output_files_1
      - id: output_files_2
    run: ../../SplitPairByMetadata/sbg-split-pair-by-metadata-v1.cwl
    label: SBG Split Pair by Metadata CWL
    'sbg:x': -128.6840362548828
    'sbg:y': 862.371337890625
requirements: []
'sbg:toolAuthor': 'Matthew Wyczalkowski, Hua Sun, Song Cao'
