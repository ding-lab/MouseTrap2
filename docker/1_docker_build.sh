IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest"
docker build -t $IMAGE .

IMAGE_MGI="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:mgi"
docker build -t $IMAGE_MGI .

# docker push $IMAGE
