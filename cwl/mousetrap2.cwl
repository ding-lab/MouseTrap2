class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: mousetrap2
baseCommand:
  - bash
  - /usr/local/MouseTrap2/MouseTrap2.sh
inputs:
  - id: FQ1
    type: File
    inputBinding:
      position: 0
      prefix: '-1'
    label: PDX FASTQ R1
    doc: Require either one BAM or two FASTQs
  - id: FQ2
    type: File
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
  - id: SAMPLE
    type: string
    inputBinding:
      position: 0
      prefix: '-s'
outputs:
  - id: disambiguate_human_bam
    type: File
    outputBinding:
      glob: '*.disambiguate_human.bam'
    secondaryFiles:
      - .bai
label: MouseTrap2
arguments:
  - position: 0
    prefix: '-G'
requirements:
  - class: ResourceRequirement
    ramMin: 16000
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest'
  - class: InlineJavascriptRequirement
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
