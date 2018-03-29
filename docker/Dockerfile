# Based on https://github.com/ding-lab/dockers/blob/master/samtools_bwa_picard_disambiguate/Dockerfile

FROM hsun9/disambiguateplus

USER root
RUN apt-get update \
    && apt-get install -y vim-tiny \
    && apt-get clean

USER biodocker

# following invocation will create common data dir in ./
# docker run -v $PWD/data:/data -it breakpoint_surveyor

VOLUME ["/data"]

