class: Workflow
cwlVersion: v1.0
id: mousefilter2_tindaisy_workflow
label: MouseFilter2.TinDaisy.workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: input_pair
    type: 'File[]'
    label: Input FASTQ
    'sbg:x': -769.340087890625
    'sbg:y': -44.40345764160156
  - id: HGFA
    type: File
    label: Human Reference
    'sbg:x': -469.682861328125
    'sbg:y': -369.5
  - id: MMFA
    type: File
    label: Mouse Reference
    'sbg:x': -467.03167724609375
    'sbg:y': -220.97982788085938
  - id: varscan_config
    type: File
    'sbg:x': -166.8235321044922
    'sbg:y': -611.6752319335938
  - id: strelka_config
    type: File
    'sbg:x': -167.61029052734375
    'sbg:y': -493.6899108886719
  - id: pindel_config
    type: File
    'sbg:x': -171.13970947265625
    'sbg:y': -371.63751220703125
  - id: dbsnp_db
    type: File
    'sbg:x': 22.477941513061523
    'sbg:y': 53.72793960571289
outputs:
  - id: output_dat
    outputSource:
      - workflow_v1_2/output_dat
    type: File
    'sbg:x': 509.88275146484375
    'sbg:y': -138.4665069580078
steps:
  - id: workflow_v1_1
    in:
      - id: HGFA
        source: HGFA
      - id: MMFA
        source: MMFA
      - id: input_pair
        source:
          - sbg_split_pair_by_metadata_v1/output_files_1
    out:
      - id: disambiguate_human
    run: ./RemoveMouseReads.workflow.cwl
    label: workflow-v2
    'sbg:x': -243
    'sbg:y': -39
  - id: workflow_v1_2
    in:
      - id: tumor_bam
        source: workflow_v1_1/disambiguate_human
      - id: strelka_config
        source: strelka_config
      - id: reference_fasta
        source: HGFA
      - id: normal_bam
        source: fq2bam_workflow/output
      - id: varscan_config
        source: varscan_config
      - id: pindel_config
        source: pindel_config
      - id: dbsnp_db
        source: dbsnp_db
    out:
      - id: output_dat
    run: ../../TinDaisy/cwl/TinDaisy.workflow.cwl
    label: TinDaisy Workflow
    'sbg:x': 187.1774139404297
    'sbg:y': -136.4596710205078
  - id: fq2bam_workflow
    in:
      - id: input_pair
        source:
          - sbg_split_pair_by_metadata_v1/output_files_2
      - id: reference
        source: HGFA
    out:
      - id: output
    run: ./fq2bam-workflow.cwl
    label: FQ2BAM.workflow
    'sbg:x': -253
    'sbg:y': -194
  - id: sbg_split_pair_by_metadata_v1
    in:
      - id: input_pair
        source:
          - input_pair
    out:
      - id: output_files_1
      - id: output_files_2
    run: ../../SplitPairByMetadata/sbg-split-pair-by-metadata-v1.cwl
    label: SBG Split Pair by Metadata CWL
    'sbg:x': -519.4725952148438
    'sbg:y': -46.285301208496094
requirements:
  - class: SubworkflowFeatureRequirement
