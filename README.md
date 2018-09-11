# MouseTrap2: A better mouse filter

MouseTrap2 is a mouse read filter and variant caller for PDX WES / WXS data.

## Installation
MouseTrap2 requires several packages to run.

**[Install Docker](https://www.docker.com/community-edition)**
Be sure it is running before running `rabix`.

**Install [MouseTrap2](https://github.com/ding-lab/MouseTrap2)**
```
git clone --recursive https://github.com/ding-lab/MouseTrap2
```
Note this will install [TinDaisy](https://github.com/ding-lab/tin-daisy) as a submodule in the `MouseTrap2/tin-daisy` directory.

**[Install Rabix Executor](https://github.com/rabix/bunny)**
```
wget https://github.com/rabix/bunny/releases/download/v1.0.5-1/rabix-1.0.5.tar.gz -O rabix-1.0.5.tar.gz && tar -xvf rabix-1.0.5.tar.gz
```

Test Rabix Executor with,
```
cd rabix-cli-1.0.5
./rabix examples/dna2protein/dna2protein.cwl.json examples/dna2protein/inputs.json
```
This should run for a few seconds and then produce output like,
```
[2018-04-20 14:38:24.655] [INFO] Job root.Translate has completed
{
  "output_protein" : {
    "basename" : "protein.txt",
    "checksum" : "sha1$55adf0ec2ecc6aee57a774d48216ac5a97d6e5ba",
    "class" : "File",
    "contents" : null,
    "dirname" : "/Users/mwyczalk/tmp/tin-daisy/rabix-cli-1.0.5/examples/dna2protein/dna2protein.cwl-2018-04-20-143817.231/root/Translate",
    "format" : null,
    "location" : "file:///Users/mwyczalk/tmp/tin-daisy/rabix-cli-1.0.5/examples/dna2protein/dna2protein.cwl-2018-04-20-143817.231/root/Translate/protein.txt",
    "metadata" : null,
    "nameext" : ".txt",
    "nameroot" : "protein",
    "path" : "/Users/mwyczalk/tmp/tin-daisy/rabix-cli-1.0.5/examples/dna2protein/dna2protein.cwl-2018-04-20-143817.231/root/Translate/protein.txt",
    "secondaryFiles" : [ ],
    "size" : 9
  }
}
```

Install Rabix Composer (optional but recommended)


## Log into CGC

In some cases (all?) it is necessary to log into CGC to pull latest somatic-wrapper image.  To do this,
`docker login cgc-images.sbgenomics.com`
Username is normal, password is token string obtained from CGC: https://cgc.sbgenomics.com

It is often necessary to do a `docker pull` to update the docker image.
```
docker pull cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:20180910
```

## Run MouseTrap2 on test dataset
To run the entire MouseTrap2 workflow on a test dataset (named "NIX5"),
```
bash run.MouseTrap2.sh
```
This will run for about 30 minutes.  Note that need to prep references *TODO* 

# Old notes below (TODO)


## FASTQ input datasets

Need sequence data as FASTQ read pairs, both tumor and normal (4 FASTQ files total)

### NIX5.10K dataset
```
D=/Users/mwyczalk/Projects/Rabix/MouseTrap2/test-dat
FQ1="$D/NIX5.10K.R1.fastq.gz"
FQ2="$D/NIX5.10K.R2.fastq.gz"
```

This is a human + Mouse synthetic mixture, used for testing MouseTrap2.
For now, these will serve as both tumor and normal

```
FQ1_TUMOR=$FQ1
FQ2_TUMOR=$FQ2
FQ1_NORMAL=$FQ1
FQ2_NORMAL=$FQ2
```

### SBG data

From Metadata code shared with me via email,
```
/Users/mwyczalk/Projects/Rabix/Metadata/pair_fastq/data
-rw-r--r--  2 mwyczalk  staff  670572 May 23 10:07 SRR7030206_1_sm2.fastq
-rw-r--r--  2 mwyczalk  staff  670572 May 23 10:07 SRR7030206_2_sm2.fastq
-rw-r--r--  2 mwyczalk  staff   36433 May 23 10:03 example_human_Illumina.pe_1.fastq
-rw-r--r--  2 mwyczalk  staff   36433 May 23 10:03 example_human_Illumina.pe_2.fastq
```
We are not using this currently

### config data
Here's a local installation of Somatic Wrapper.  Use those params
`/Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/params`

## Rest of it
```
Human Ref:
/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference/GRCh37-lite.fa
Mouse Ref:
/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa
Pindel Config:
/Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/params/pindel.WES.ini
Varscan Config:
/Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/params/varscan.WES.ini
Strelka Config:
/Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/params/strelka.WES.ini
Centromere BED: - none
VEP Cache DB: - none
dbSNP DB:
/Users/mwyczalk/Data/SomaticWrapper/image/B_Filter/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz
```


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

## Test Data: NIX5.10K

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
