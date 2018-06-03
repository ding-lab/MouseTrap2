# MouseTrap2: A better mouse filter

# Notes about MGI testing (ongoing)

Currently started script `launch.MouseTrap2.docker-MGI.realdata.sh`
* analysis of data provided by Hua:
  `/gscmnt/gc2612/whim_pdx_hamlet_xenograft/model_data/f8cc6fae4e784e41864b680d679246f8/build2ac9536b9e6b43f3a568baffb5974d40/alignments/94bf7538283c4e06b7e789b1d0eb848b.bam`
  * Huas results:
  `/gscmnt/gc2737/ding/hsun/pdx/test.disambiguate_somaticWrapper/wxs_disam_sw_plus/human_mouse/346`
* Script started 6/3/18
  * Output in
    `/gscmnt/gc2508/dinglab/mwyczalk/MouseTrap2.data/results`

## Launch vs. Run


This is a CWL version of Hua Suns mouse filter.

# Quick start

## Launch from within docker container
```
bash docker/launch_docker.sh
# git pull origin master
# bash run.MouseTrap2.docker.sh
```
(`#` is from within docker container)


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

We will be using a docker image which is an extension of Hua Sun's [hsun9/disambiguateplus]
That dockerfile can be found in `orig/Dockerfile.disambiguate`, but we won't it directly.

[hsun9/disambiguateplus]: https://github.com/ding-lab/dockers/blob/master/samtools_bwa_picard_disambiguate/Dockerfile

### Updates to Dockerfile

We create a new image based on `hsun9/disambiguateplus` with the following changes:

* vim-tiny is installed

The new image is created with `docker/Dockerfile` and tagged as, `cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest`

## Processing Script

The original script as obtained from Hua Sun is `orig/run.lsf.disambiguate.pl`.  This is modified to create the 
script `MouseTrap2.sh`

# Testing

There are several levels of testing and development that take place here:

1. Test the script directly by running it in bash from the command line
    This is typically the first step, but requires that all applications be installed on the localhost.
2. Run MouseTrap2.sh inside of docker
3. Run MouseTrap2 as a CWL tool
4. Run MouseTrap2 as a CWL workflow

## Docker testing

### Dockerfile

Preliminary testing will take within docker container (because not all packages are installed on localhost).

Script for launching docker container is `run_docker_adhoc.sh`.  There, two volumes are mounted:
```
data1: /Users/mwyczalk/Data/SomaticWrapper/image/A_Reference
data2: /Users/mwyczalk/Projects/Rabix/MouseTrap2/test-dat
```
These will allow the container to see the test data we're using

### Memory issues

`bwa mem` requires 6Gb of memory or so (8 has worked), and this needs to be set in two places:
* In the script `run_docker_adhoc.sh`
* On Docker for Mac, need to go to the whale icon, Preferences, Advanced to set the amount of resources Docker can use. Press save and restart button.  Setting this to 8 has worked.

You can monitor memory usage of containers with `docker stats`.

## CWL Tool

`MouseTrap2.cwl` was developed using Rabix Composer.
