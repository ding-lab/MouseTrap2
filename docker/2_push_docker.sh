IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:latest"
docker push $IMAGE 

echo Skipping MGI
exit
IMAGE_MGI="cgc-images.sbgenomics.com/m_wyczalkowski/disambiguate:mgi"
docker push $IMAGE_MGI

