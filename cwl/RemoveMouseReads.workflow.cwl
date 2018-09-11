class: Workflow
cwlVersion: v1.0
id: _remove_mouse_reads
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
  - id: SAMPLE
    type: string
    'sbg:exposed': true
outputs:
  - id: disambiguate_human_bam
    outputSource:
      - disambiguate_filter/disambiguate_human_bam
    type: File
    'sbg:x': 746.8125
    'sbg:y': 45.5
steps:
  - id: disambiguate_filter
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
      - id: SAMPLE
        source: SAMPLE
    out:
      - id: disambiguate_human_bam
    run: ./disambiguate_filter.cwl
    label: disambiguate_filter
    'sbg:x': 399.4483642578125
    'sbg:y': 39.4140625
requirements: []
'sbg:toolAuthor': 'Matthew Wyczalkowski, Hua Sun, Song Cao'
