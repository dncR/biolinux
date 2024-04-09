#!/bin/bash

## Install R from source.
##
## In order of preference, first argument of the script, the R_VERSION variable.
## ex. latest, devel, patched, 4.0.0
##
## 'devel' means the prerelease development version (Latest daily snapshot of development version).
## 'patched' means the prerelease patched version (Latest daily snapshot of patched version).

set -e

ARCH=${ARCH:-"arm64"}

# shellcheck source=/dev/null
source /etc/os-release

apt-get update
apt-get -y install locales

## Configure default locale
LANG=${LANG:-"en_US.UTF-8"}
/usr/sbin/locale-gen --lang "${LANG}"
/usr/sbin/update-locale --reset LANG="${LANG}"

# Install Linux libraries.
apt-get update
apt-get install -y \
    curl \
    g++ \
    gfortran \
    libblas-dev \
    libbz2-* \
    libcurl4 \
    make \
    tzdata \
    unzip \
    zip \
    zlib1g \
    wget \
    nano \
    libx11-dev \
    xxd \
    perl \
    tcl-dev \
    tk-dev \
    zlib1g-dev \
    libhts-dev

# Install Java and Reconfigure Java for R
apt-get update && apt-get install -y \
	default-jdk

# Install RNASeq Tools
apt install -y \
	fastqc \
	samtools

# Get latest STAR source from releases
cd /opt
wget https://github.com/alexdobin/STAR/archive/2.7.11b.tar.gz
tar -xzf 2.7.11b.tar.gz
rm -f 2.7.11b.tar.gz

mv STAR* STAR
cd /opt/STAR/source

if [ "${ARCH}" == "arm64" ]; then
	make CXXFLAGS_SIMD=-std=c++11 STARstatic
else
	make STAR 
fi

if [ "$(/opt/STAR/source/STAR --version)" == "2.7.11b" ]; then
	echo 'export PATH="/opt/STAR/source:$PATH"' >> ~/.bashrc
	source ~/.bashrc
fi

# Check if STAR is successfully installed from source.
echo $(STAR --version)

# Install featureCounts (available thorugh ubuntu package "subread").
apt install -y subread
















