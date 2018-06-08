class: Workflow
cwlVersion: v1.0
id: fq2bam_workflow
label: FQ2BAM.workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: input_pair
    type: 'File[]'
    'sbg:x': -534
    'sbg:y': 60
  - id: reference
    type: File
    'sbg:x': -318.9443664550781
    'sbg:y': -106
outputs:
  - id: output
    outputSource:
      - fq2bam/output
    type: File?
    'sbg:x': 285.0556335449219
    'sbg:y': 79
steps:
  - id: fq2bam
    in:
      - id: FQ1
        source:
          - sbg_split_pair_by_metadata_v1/output_files_1
      - id: FQ2
        source:
          - sbg_split_pair_by_metadata_v1/output_files_2
      - id: reference
        source: reference
    out:
      - id: output
    run: ./fq2bam.cwl
    label: fq2bam
    'sbg:x': 120
    'sbg:y': 75
  - id: sbg_split_pair_by_metadata_v1
    in:
      - id: input_pair
        source:
          - input_pair
      - id: metadata_criteria
        default:
          output_1: 'read_pair:1'
          output_2: 'read_pair:2'
    out:
      - id: output_files_1
      - id: output_files_2
    run: ../../SplitPairByMetadata/sbg-split-pair-by-metadata-v1.cwl
    label: SBG Split Pair by Metadata CWL
    'sbg:x': -317
    'sbg:y': 59
requirements: []
