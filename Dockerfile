FROM python:3.8-slim

LABEL base_image="python:3.8-slim"
LABEL software="TIDDIT.py"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    git \
    libbz2-dev \
    libcurl4-gnutls-dev \
    liblzma-dev \
    libncurses5-dev \
    libssl-dev \
    make \
    wget \
    zlib1g-dev && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

## Install samtools for cram processing
RUN wget --no-verbose https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 && \
    bunzip2 samtools-1.10.tar.bz2 && \
    tar -xf samtools-1.10.tar && \
    cd samtools-1.10 && \
    ./configure && \
    make all all-htslib && \
    make install install-htslib && \
    rm /app/samtools-1.10.tar

## Clone and install
RUN git clone https://github.com/jemten/TIDDIT.git && \
    cd TIDDIT && \
    ./INSTALL.sh && \
    chmod +x /app/TIDDIT/TIDDIT.py && \
    ln -s /app/TIDDIT/TIDDIT.py /usr/local/bin 

ENTRYPOINT ["TIDDIT.py"]
CMD ["--help"]
