# Run docker image with a given volume mounted

IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest"

INSTALLD="/Users/mwyczalk/Data/SomaticWrapper/image/A_Reference"
MEM="-m 8g"

docker run $MEM -v $DATAD:/data -it $IMAGE bash
