# MouseTrap2: A better mouse filter

This is a CWL version of Hua Song's mouse filter.

# Local testing and development

## Reference data

Reference data here: `/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference`
* `GRCh37-lite.fa`
* `Mus_musculus.GRCm38.dna_sm.primary_assembly.fa`

These files were downloaded from MGI and processed with scripts like those here: 
`/Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/image.setup/A_Reference`
Note that this processing took place within the docker container described below, which 
has the necessary tools, and which was run with `run_docker_adhoc.sh`.

## Test Data

The `NIX5.10K` dataset consists of the first 10K reads of the `14311X5` sample.  It is obtained from
`/gscuser/mwyczalk/projects/PDXnet/MouseTrap2/TestData/dat`

That data is based on that available on CGC "HCI - Data - WES Mixtures" project,
which is downloaded on MGI here: `/gscmnt/gc2619/dinglab_cptac3/CGC_import`

```
    WES of experimental human/mouse mixtures provided by Bryan Welm (HCI)
    Library prep protocol: Agilent SureSelect XT Human All Exon V6+COSMIC
    Seq protocol: HiSeq 125 Cycle Paired-End Sequencing v4
    Sequencing depth: ~100X
    Patient ID: 0247
    Sample ID   Mixture Description
    14311X1 0247_Blood  100% Human DNA
    14311X2 0247_Patient    100% Human DNA
    14311X3 0247_90:10  90% human DNA and 10 % mouse DNA
    14311X4 0247_80:20  80% human DNA and 20 % mouse DNA
    14311X5 0247_60:40  60% human DNA and 40 % mouse DNA  *** NIX5.10K test dataset ***
    14311X6 0247_40:60  40% human DNA and 60 % mouse DNA
    14311X7 0247_20:80  20% human DNA and 80 % mouse DNA
    14311X8 nodscid_mouse   100% mouse DNA
```

## Dockerfile

We will be using a docker image which is an extension of Hua Song's [hsun9/disambiguateplus]
That dockerfile can be found in `docker/Dockerfile.disambiguate`, but we won't it directly.

[hsun9/disambiguateplus]: https://github.com/ding-lab/dockers/blob/master/samtools_bwa_picard_disambiguate/Dockerfile

### Updates to Dockerfile

We create a new image based on `hsun9/disambiguateplus` with the following changes:

* vim-tiny is installed

The new image is created with `docker/Dockerfile` and tagged as, `cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest`

