# Based on https://github.com/ding-lab/dockers/blob/master/samtools_bwa_picard_disambiguate/Dockerfile

FROM hsun9/disambiguateplus

USER root
RUN apt-get update \
    && apt-get install -y vim \
    && apt-get clean

# do: get this from somaticwrapper
COPY init/vimrc /home/biodocker/.vimrc

ENV foo redo8       # this can be modified at will to force cloning latest version of MouseTrap2
RUN cd /usr/local \
    && git clone https://github.com/ding-lab/MouseTrap2.git

WORKDIR /usr/local/MouseTrap2

