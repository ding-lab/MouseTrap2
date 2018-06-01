# Run docker image with the given volumes mounted for testing
# MGI version

IMAGE_MGI="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate"
#IMAGE_MGI="mwyczalkowski/somatic-wrapper:latest"

## reference stuff in /data1
#DATA1="/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference"
## test FASTQs in /data2
#DATA2="/Users/mwyczalk/Projects/Rabix/MouseTrap2/test-dat"
#MEM="--memory 6g"  # `git stats` indicated memory usage as high as 5.1Gb

MEMGB=8
LSF_ARGS="-R \"rusage[mem=${MEMGB}000]\" -M ${MEMGB}000000"

bsub -q research-hpc $LSF_ARGS -Is -a "docker($IMAGE_MGI)" "/bin/bash --rcfile /home/sw/.bashrc"
