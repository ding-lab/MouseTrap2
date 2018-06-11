IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest"
docker build -t $IMAGE .

echo Skipping MGI
exit
IMAGE_MGI="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:mgi"
docker build -f Dockerfile.mgi -t $IMAGE_MGI .

# docker push $IMAGE
