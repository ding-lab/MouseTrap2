class: CommandLineTool
cwlVersion: v1.0
id: mousetrap2
baseCommand:
  - bash
  - /usr/local/MouseTrap2/MouseTrap2.sh
inputs:
  - id: BAM
    type: File?
    inputBinding:
      position: 0
      prefix: '-b'
    label: PDX BAM file
    doc: Require either one BAM or two FASTQs
  - id: FQ1
    type: File?
    inputBinding:
      position: 0
      prefix: '-1'
    label: PDX FASTQ R1
    doc: Require either one BAM or two FASTQs
  - id: FQ2
    type: File?
    inputBinding:
      position: 0
      prefix: '-2'
    label: PDX FASTQ R2
    doc: Require either one BAM or two FASTQs
  - id: HGFA
    type: File
    inputBinding:
      position: 0
      prefix: '-h'
    label: Human reference FASTA
  - id: MMFA
    type: File
    inputBinding:
      position: 0
      prefix: '-m'
    label: Mouse reference FASTA
  - id: sample_name
    type: string?
    inputBinding:
      position: 0
      prefix: '-s'
outputs:
  - id: mouse.bam
    type: File
    outputBinding:
      glob: hgmm.mouseFiltered.remDup.bam
    secondaryFiles:
      - .bai
label: MouseTrap2
requirements:
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest'
'sbg:job':
  inputs:
    BAM:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    FQ1:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    FQ2:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    HGFA:
      basename: j.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: j
      path: /path/to/j.ext
      secondaryFiles: []
      size: 0
    MMFA:
      basename: input_1.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input_1
      path: /path/to/input_1.ext
      secondaryFiles: []
      size: 0
    sample_name: sample_name-string-value
  runtime:
    cores: 1
    ram: 8000
