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
  - id: FQ2
    type: File
    label: Normal FASTQ 2
    'sbg:x': -465.53668212890625
    'sbg:y': -259.1880798339844
  - id: FQ1
    type: File
    label: Normal FASTQ 1
    'sbg:x': -466.28509521484375
    'sbg:y': -122.23890686035156
  - id: MMFA
    type: File
    'sbg:x': -507.0296936035156
    'sbg:y': 54.53821563720703
  - id: FQ2_PDX
    type: File
    'sbg:x': -527.6841430664062
    'sbg:y': 244.1834716796875
  - id: FQ1_PDX
    type: File
    'sbg:x': -523.9287719726562
    'sbg:y': 456.34393310546875
  - id: varscan_config
    type: File
    'sbg:x': -240.85452270507812
    'sbg:y': -643.590576171875
  - id: strelka_config
    type: File
    'sbg:x': -244.19549560546875
    'sbg:y': -502.1966857910156
  - id: pindel_config
    type: File
    'sbg:x': -250.84228515625
    'sbg:y': -369.87017822265625
  - id: dbsnp_db
    type: File
    'sbg:x': -94.74201965332031
    'sbg:y': 299.1309509277344
  - id: output_vep
    type: string?
    'sbg:exposed': true
  - id: centromere_bed
    type: File?
    'sbg:x': 133.1365966796875
    'sbg:y': 347.47259521484375
  - id: assembly
    type: string
    'sbg:exposed': true
  - id: no_delete_temp
    type: int?
    'sbg:exposed': true
  - id: vep_cache_gz
    type: File?
    'sbg:x': 79.5000228881836
    'sbg:y': -622.212890625
  - id: SampleName
    type: string
    doc: >-
      Arbitrary name which will form basis of output directory naming scheme. 
      It is also incorporated into headers when aligning
    'sbg:x': -768.0919799804688
    'sbg:y': -54.6670036315918
outputs:
  - id: output_dat
    outputSource:
      - workflow_v1_1/output_dat
    type: File
    'sbg:x': 937.1414794921875
    'sbg:y': -175.2516632080078
steps:
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
      - id: sample
        source: SampleName
    out:
      - id: output
    run: ./fq2bam-workflow.cwl
    label: FQ2BAM.workflow
    'sbg:x': -253
    'sbg:y': -194
  - id: _remove_mouse_reads
    in:
      - id: HGFA
        source: HGFA
      - id: MMFA
        source: MMFA
      - id: FQ2
        source: FQ2_PDX
      - id: FQ1
        source: FQ1_PDX
      - id: SAMPLE
        source: SampleName
    out:
      - id: disambiguate_human_bam
    run: ./RemoveMouseReads.workflow.cwl
    label: Remove Mouse Reads
    'sbg:x': -247.90966796875
    'sbg:y': 13.230426788330078
  - id: workflow_v1_1
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
      - id: output_vep
        source: output_vep
      - id: centromere_bed
        source: centromere_bed
      - id: no_delete_temp
        source: no_delete_temp
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: tumor_bam
        source: _remove_mouse_reads/disambiguate_human_bam
      - id: assembly
        default: GRCh37
        source: assembly
      - id: results_dir
        source: SampleName
    out:
      - id: output_dat
    run: ../../TinDaisy/cwl/TinDaisy.workflow.cwl
    label: TinDaisy Workflow
    'sbg:x': 488.82086181640625
    'sbg:y': -154.65476989746094
requirements:
  - class: SubworkflowFeatureRequirement
