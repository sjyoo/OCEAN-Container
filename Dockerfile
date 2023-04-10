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

## libxc installation
RUN curl https://gitlab.com/libxc/libxc/-/archive/4.3.4/libxc-4.3.4.tar.gz -O -L
RUN tar xvfz libxc-4.3.4.tar.gz \
    && rm -rf libxc-4.3.4.tar.gz 
RUN cd libxc-4.3.4 \
    && autoreconf --install \
    && ./configure --prefix=/usr/local \
    && make all \
    && make install

## ONCV PSP installation
RUN curl https://github.com/jtv3/oncvpsp/archive/refs/tags/4.tar.gz -O -L
RUN tar xvfz 4.tar.gz \
    && rm -rf 4.tar.gz
COPY make.inc /usr/local/src/oncvpsp-4/
RUN cd oncvpsp-4 \
    && make \
    && cp src/*.x /usr/local/bin

## Quantum espresso installation
RUN curl https://github.com/QEF/q-e/releases/download/qe-6.8/qe-6.8-ReleasePack.tgz -O -L
RUN tar xvfz qe-6.8-ReleasePack.tgz \
    && rm -rf qe-6.8-ReleasePack.tgz
RUN cd qe-6.8 \
    && ./configure --with-libxc --with-libxc-prefix=/usr/local \
    && make all \
    && make install
RUN cp /usr/local/bin/p?.x /usr/bin 


## Ocean installation
WORKDIR /usr/local/src
RUN curl https://github.com/times-software/OCEAN/archive/refs/tags/v3.0.0.tar.gz -O -L
RUN tar xvf v3.0.0.tar.gz \
    && rm -rf v3.0.0.tar.gz 
COPY Makefile* /usr/local/src/OCEAN-3.0.0/
RUN cd OCEAN-3.0.0 \
    && make all \
    && make install

RUN mkdir -p /work

WORKDIR /work
