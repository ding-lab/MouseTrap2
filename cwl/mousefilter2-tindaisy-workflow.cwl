class: Workflow
cwlVersion: v1.0
id: mousefilter2_tindaisy_workflow
label: MouseFilter2.TinDaisy.workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: HGFA
    type: File
    label: Human Reference
    'sbg:x': -469.682861328125
    'sbg:y': -369.5
  - id: MMFA
    type: File
    label: Mouse Reference
    'sbg:x': -481.14678955078125
    'sbg:y': 3.990825653076172
  - id: FQ2
    type:
      - File
      - type: array
        items: File
    label: Normal FASTQ 2
    'sbg:x': -465.53668212890625
    'sbg:y': -259.1880798339844
  - id: FQ1
    type:
      - File
      - type: array
        items: File
    label: Normal FASTQ 1
    'sbg:x': -466.28509521484375
    'sbg:y': -122.23890686035156
  - id: PDX_FQ2
    type: File
    label: PDX FASTQ 2
    'sbg:x': -480.1957702636719
    'sbg:y': 164.58934020996094
  - id: PDX_FQ1
    type: File
    label: PDX FASTQ 1
    'sbg:x': -474.53204345703125
    'sbg:y': 309.0143127441406
  - id: varscan_config
    type: File
    'sbg:x': -198.06065368652344
    'sbg:y': -701.4611206054688
  - id: strelka_config
    type: File
    'sbg:x': -198.53456115722656
    'sbg:y': -575.2706298828125
  - id: pindel_config
    type: File
    'sbg:x': -190.29898071289062
    'sbg:y': -427.0299987792969
  - id: dbsnp_db
    type: File
    'sbg:x': -253.09500122070312
    'sbg:y': 137.4391632080078
  - id: centromere_bed
    type: File?
    'sbg:x': -257.7527770996094
    'sbg:y': 287.66363525390625
  - id: vep_cache_gz
    type: File?
    'sbg:x': -206.3383331298828
    'sbg:y': -812.2908325195312
outputs:
  - id: output_dat
    outputSource:
      - workflow_v1_2/output_dat
    type: File
    'sbg:x': 358.19134521484375
    'sbg:y': -245.8470001220703
steps:
  - id: workflow_v1_1
    in:
      - id: HGFA
        source: HGFA
      - id: MMFA
        source: MMFA
      - id: FQ2
        source: PDX_FQ2
      - id: FQ1
        source: PDX_FQ1
    out:
      - id: disambiguate_human
    run: ./RemoveMouseReads.workflow.cwl
    label: workflow-v2
    'sbg:x': -243
    'sbg:y': -39
  - id: fq2bam_workflow
    in:
      - id: reference
        source: HGFA
      - id: FQ2
        source:
          - FQ2
      - id: FQ1
        source:
          - FQ1
    out:
      - id: output
    run: ./fq2bam-workflow.cwl
    label: FQ2BAM.workflow
    'sbg:x': -253
    'sbg:y': -194
  - id: workflow_v1_2
    in:
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
      - id: centromere_bed
        source: centromere_bed
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: tumor_bam
        source: workflow_v1_1/disambiguate_human
    out:
      - id: output_dat
    run: ../../TinDaisy/cwl/TinDaisy.workflow.cwl
    label: TinDaisy Workflow
    'sbg:x': 127.88053131103516
    'sbg:y': -244.84402465820312
requirements:
  - class: SubworkflowFeatureRequirement
