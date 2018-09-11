* `test-data contains` NIX5 dataset, which is subset of data from CGC with human + mouse reads (details below)
  * this is not a particularly good dataset for TinDaisy, since no variants are discovered
  * TODO: create small test dataset with variants and mouse read contamination 
* Scripts here are designed to test MouseTrap2 in various contexts

# Test scripts

## Running within docker

The most straightforward way to run DisambiguateFilter.sh is from within a docker container.

* `launch_docker.sh` will start a docker container and allow user to run interactive (bash) session in it.
    * Once in interactive session within container, can execute `run.DisambiguateFilter.sh` within it
* `launch_docker.DisambiguateFilter.sh` will start docker container and run DisambiguateFilter.sh
  within it directly.

## Running using CWL

CWL tools and workflows are run directly from host computer using `rabix`, without need to explicitly
start docker container.  These come in two flavors:

**rename MouseTrap2 to DisambiguateFilter**

* :


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
