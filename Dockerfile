# docker build -t hosocean .
# docker run -it hosocean /bin/bash

FROM debian:9-slim
LABEL maintainer "guillaume.jacquenot@gmail.com"

RUN apt-get update && \
    apt-get install -y \
        gfortran \
        cmake && \
    apt update && apt install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gnupg \
        wget && \
    wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list' && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        cpio \
        intel-mkl-core-2019.5-281 \
        intel-mkl-gnu-f-2019.5-281

WORKDIR .
ADD . /hos-ocean
RUN cd /hos-ocean && \
    cd cmake && \
    mkdir -p build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make test

# RUN cd /hos-ocean && \
#     cd cmake && \
#     mkdir -p build && \
#     cd build && \
#     cmake .. -DCMAKE_BUILD_TYPE=Coverage && \
#     make && \
#     make test && \
#     make coverage
