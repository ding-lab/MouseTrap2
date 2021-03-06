class: Workflow
cwlVersion: v1.0
id: mousetrap2_workflow
label: MouseTrap2.workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: HGFA
    type: File
    label: Human Reference
    'sbg:x': -469.682861328125
    'sbg:y': -369.5
  - id: FQ2
    type: File
    label: Normal FASTQ 2
    'sbg:x': -465.53668212890625
    'sbg:y': -259.1880798339844
  - id: FQ1
    type: File
    label: Normal FASTQ 1
    'sbg:x': -466.28509521484375
    'sbg:y': -122.23890686035156
  - id: MMFA
    type: File
    'sbg:x': -507.0296936035156
    'sbg:y': 54.53821563720703
  - id: FQ2_PDX
    type: File
    'sbg:x': -527.6841430664062
    'sbg:y': 244.1834716796875
  - id: FQ1_PDX
    type: File
    'sbg:x': -523.9287719726562
    'sbg:y': 456.34393310546875
  - id: varscan_config
    type: File
    'sbg:x': -240.85452270507812
    'sbg:y': -643.590576171875
  - id: strelka_config
    type: File
    'sbg:x': -244.19549560546875
    'sbg:y': -502.1966857910156
  - id: pindel_config
    type: File
    'sbg:x': -250.84228515625
    'sbg:y': -369.87017822265625
  - id: dbsnp_db
    type: File
    'sbg:x': -94.74201965332031
    'sbg:y': 299.1309509277344
  - id: centromere_bed
    type: File?
    'sbg:x': 133.1365966796875
    'sbg:y': 347.47259521484375
  - id: assembly
    type: string?
    'sbg:exposed': true
  - id: is_strelka2
    type: boolean?
    'sbg:exposed': true
  - id: no_delete_temp
    type: int?
    'sbg:exposed': true
  - id: vep_cache_gz
    type: File?
    'sbg:x': 79.5000228881836
    'sbg:y': -622.212890625
  - id: vep_cache_version
    type: string?
    'sbg:exposed': true
  - id: SampleName
    type: string
    doc: >-
      Arbitrary name which will form basis of output directory naming scheme. 
      It is also incorporated into headers when aligning
    'sbg:x': -865.9449462890625
    'sbg:y': -150.0244598388672
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 329.0263977050781
    'sbg:y': -589.2855224609375
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': 207.93043518066406
    'sbg:y': -418.2581787109375
  - id: af_filter_config
    type: File
    'sbg:x': 379.6164855957031
    'sbg:y': 126.0184097290039
  - id: classification_filter_config
    type: File
    'sbg:x': 211.06561279296875
    'sbg:y': 124.452880859375
  - id: bypass_merge_vcf
    type: boolean?
    'sbg:exposed': true
  - id: bypass_vep_annotate
    type: boolean?
    'sbg:exposed': true
  - id: bypass_parse_pindel
    type: boolean?
    'sbg:exposed': true
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': 231.86190795898438
    'sbg:y': -693.0210571289062
outputs:
  - id: output_vcf
    outputSource:
      - TinDaisy/output_vcf
    type: File
    'sbg:x': 847.978271484375
    'sbg:y': -312.859130859375
  - id: merged_maf
    outputSource:
      - TinDaisy/merged_maf
    type: File
    'sbg:x': 852.86083984375
    'sbg:y': -22.344951629638672
steps:
  - id: TinDaisy
    in:
      - id: strelka_config
        source: strelka_config
      - id: reference_fasta
        source: HGFA
      - id: normal_bam
        source: fq2bam/output
      - id: varscan_config
        source: varscan_config
      - id: pindel_config
        source: pindel_config
      - id: dbsnp_db
        source: dbsnp_db
      - id: centromere_bed
        source: centromere_bed
      - id: no_delete_temp
        source: no_delete_temp
      - id: tumor_bam
        source: disambiguate_filter/disambiguate_human_bam
      - id: results_dir
        source: SampleName
      - id: is_strelka2
        default: false
        source: is_strelka2
      - id: pindel_vcf_filter_config
        source: pindel_vcf_filter_config
      - id: varscan_vcf_filter_config
        source: varscan_vcf_filter_config
      - id: strelka_vcf_filter_config
        source: strelka_vcf_filter_config
      - id: assembly
        default: GRCh37
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: bypass_merge_vcf
        source: bypass_merge_vcf
      - id: classification_filter_config
        source: classification_filter_config
      - id: af_filter_config
        source: af_filter_config
      - id: bypass_vep_annotate
        source: bypass_vep_annotate
      - id: bypass_parse_pindel
        source: bypass_parse_pindel
    out:
      - id: merged_maf
      - id: output_vcf
    run: ../tin-daisy/cwl/TinDaisy.workflow.cwl
    label: TinDaisy Workflow
    'sbg:x': 488.82086181640625
    'sbg:y': -154.65476989746094
  - id: disambiguate_filter
    in:
      - id: FQ1
        source: FQ1_PDX
      - id: FQ2
        source: FQ2_PDX
      - id: HGFA
        source: HGFA
      - id: MMFA
        source: MMFA
      - id: SAMPLE
        source: SampleName
    out:
      - id: disambiguate_human_bam
    run: ./disambiguate_filter.cwl
    label: disambiguate_filter
    'sbg:x': -171
    'sbg:y': 73
  - id: fq2bam
    in:
      - id: FQ1
        source: FQ1
      - id: FQ2
        source: FQ2
      - id: reference
        source: HGFA
      - id: sample
        source: SampleName
    out:
      - id: output
    run: ./fq2bam.cwl
    label: fq2bam
    'sbg:x': -152.4342498779297
    'sbg:y': -137.6850128173828
requirements:
  - class: SubworkflowFeatureRequirement
