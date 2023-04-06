FROM ubuntu:latest

ENV DEBIAN_FRONTEND "noninteractive"
RUN apt-get update \
    && apt-get install -y \
        git \
        vim \
        curl \
        build-essential \
        gcc \
        gfortran \
        gnuplot \
        openmpi-doc \
        openmpi-bin \
	python3-pip \
	pkg-config \
        libopenmpi-dev \
        openssl \
        libssl-dev \
        libreadline-dev \
        ncurses-dev \
        bzip2 \
	fftw3-dev \
        zlib1g-dev \
        libbz2-dev \
        libffi-dev \
        libopenblas-dev \
        liblapack-dev \
        libsqlite3-dev \
        liblzma-dev \
        libpng-dev \
	libblas-dev \
	liblapack-dev \
        libfreetype6-dev

ENV OMPI_MCA_btl_vader_single_copy_mechanism "none"
ENV OMPI_ALLOW_RUN_AS_ROOT 1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1

WORKDIR /usr/local/src

ENV PYTHONIOENCODING "utf-8"
RUN pip install pip -U \
    && pip install \
        numpy \
        scipy \
        matplotlib \
        sympy \
        pandas \
        tqdm \
        Pillow \
        ase \
        joblib \
        Cython \
        fire

## Quantum espresso installation
RUN curl https://github.com/QEF/q-e/releases/download/qe-6.8/qe-6.8-ReleasePack.tgz -O -L
RUN tar xvf qe-6.8-ReleasePack.tgz \
    && rm -rf qe-6.8-ReleasePack.tgz
RUN cd qe-6.8 \
    && ./configure \
    && make all \
    && make install
RUN cp /usr/local/bin/p?.x /usr/bin 


## Ocean installation
WORKDIR /usr/local/src
RUN curl https://github.com/times-software/OCEAN/archive/refs/tags/v3.0.3.tar.gz -O -L
RUN tar xvf v3.0.3.tar.gz \
    && rm -rf v3.0.3.tar.gz 
COPY Makefile* /usr/local/src/OCEAN-3.0.3/
RUN cd OCEAN-3.0.3 \
    && make all \
    && make install

RUN mkdir -p /work

WORKDIR /work
