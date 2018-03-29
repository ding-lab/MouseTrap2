# Run docker image with the given volumes mounted for testing

IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest"

# reference stuff in /data1
DATA1="/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference"
# test FASTQs in /data2
DATA2="/Users/mwyczalk/Projects/Rabix/MouseTrap2/test-dat"
MEM="-m 8g"

docker run $MEM -v $DATA1:/data1 -v $DATA2:/data2 -it $IMAGE bash
