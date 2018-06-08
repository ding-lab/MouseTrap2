class: Workflow
cwlVersion: v1.0
id: workflow_v1_1
doc: Washington University Mouse Filter and Somatic Caller toolset
label: Remove Mouse Reads
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: HGFA
    type: File
    label: Human Reference
    'sbg:x': 102
    'sbg:y': -25
  - id: MMFA
    type: File
    label: Mouse Reference
    'sbg:x': 170.4375
    'sbg:y': -150.171875
  - id: input_pair
    type: 'File[]'
    'sbg:x': 10
    'sbg:y': 104.828125
outputs:
  - id: disambiguate_human
    outputSource:
      - mousetrap2/disambiguate_human
    type: File
    'sbg:x': 775.4286499023438
    'sbg:y': 60.4140625
steps:
  - id: mousetrap2
    in:
      - id: FQ1
        source:
          - sbg_split_pair_by_metadata_v2/output_files_1
      - id: FQ2
        source:
          - sbg_split_pair_by_metadata_v2/output_files_2
      - id: HGFA
        source: HGFA
      - id: MMFA
        source: MMFA
    out:
      - id: disambiguate_human
    run: ./mousetrap2.cwl
    label: MouseTrap2
    'sbg:x': 399.4483642578125
    'sbg:y': 39.4140625
  - id: sbg_split_pair_by_metadata_v2
    in:
      - id: input_pair
        source:
          - input_pair
      - id: metadata_criteria
        default:
          output_1: 'paired_end:1'
          output_2: 'paired_end:2'
    out:
      - id: output_files_1
      - id: output_files_2
    run: ../../SplitPairByMetadata/sbg-split-pair-by-metadata-v1.cwl
    label: SBG Split Pair by Metadata CWL
    'sbg:x': 175.4375
    'sbg:y': 107
requirements: []
'sbg:toolAuthor': 'Matthew Wyczalkowski, Hua Sun, Song Cao'
