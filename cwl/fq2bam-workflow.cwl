class: Workflow
cwlVersion: v1.0
id: fq2bam_workflow
doc: |-
  Following metadata required for FASTQ files as input:
  * sample_type = tumor, normal
  * paired_end = 1, 2
label: FQ2BAM.workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: reference
    type: File
    'sbg:x': -318.9443664550781
    'sbg:y': -106
  - id: FQ2
    type:
      - File
      - type: array
        items: File
    'sbg:x': -149
    'sbg:y': 86
  - id: FQ1
    type:
      - File
      - type: array
        items: File
    'sbg:x': -147
    'sbg:y': 232
  - id: sample
    type: string?
    'sbg:x': -14.8984375
    'sbg:y': -73.5
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
        source: FQ1
      - id: FQ2
        source: FQ2
      - id: reference
        source: reference
      - id: sample
        source: sample
    out:
      - id: output
    run: ./fq2bam.cwl
    label: fq2bam
    'sbg:x': 120
    'sbg:y': 75
requirements: []
