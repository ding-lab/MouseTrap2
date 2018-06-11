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
  - id: FQ2
    type: File
    'sbg:x': 173.6796875
    'sbg:y': 124.5
  - id: FQ1
    type: File
    'sbg:x': 200.6796875
    'sbg:y': 244.5
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
        linkMerge: merge_flattened
        source:
          - FQ1
      - id: FQ2
        linkMerge: merge_flattened
        source:
          - FQ2
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
requirements: []
'sbg:toolAuthor': 'Matthew Wyczalkowski, Hua Sun, Song Cao'
