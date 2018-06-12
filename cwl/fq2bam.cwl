class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: fq2bam
baseCommand:
  - bash
  - /usr/local/MouseTrap2/MouseTrap2.sh
inputs:
  - id: FQ1
    type: File
    inputBinding:
      position: 10
      prefix: '-1'
  - id: FQ2
    type: File
    inputBinding:
      position: 0
      prefix: '-2'
  - id: reference
    type: File
    inputBinding:
      position: 0
      prefix: '-r'
    secondaryFiles:
      - ^.dict
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
  - id: sample
    type: string
    inputBinding:
      position: 0
      prefix: '-s'
    label: Sample name
    doc: >-
      Sample name is meant to identify different runs, and is used primarily for
      naming output names.  It is incorporated into BAM file in MouseTrap2 and
      fa2bam steps
outputs:
  - id: output
    type: File
    outputBinding:
      glob: '*.bam'
label: fq2bam
arguments:
  - position: 0
    prefix: '-c'
requirements:
  - class: ResourceRequirement
    ramMin: 16000
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest'
