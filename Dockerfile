FROM ubuntu:20.04

# Initial system
RUN apt-get -y update \
    && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
    sudo wget unzip zip xvfb ghostscript imagemagick \
    bc dc file libfontconfig1 libfreetype6 libgl1-mesa-dev \
    libgl1-mesa-dri libglu1-mesa-dev libgomp1 libice6 libxt6 \
    libxcursor1 libxft2 libxinerama1 libxrandr2 libxrender1 \
    libopenblas-base language-pack-en \
    python3-pip \
    && \
    apt-get clean

# FSL environment vars first
ENV FSLDIR="/opt/fsl" \
    PATH="/opt/fsl/bin:$PATH" \
    FSLOUTPUTTYPE="NIFTI_GZ" \
    FSLMULTIFILEQUIT="TRUE" \
    FSLTCLSH="/opt/fsl/bin/fsltclsh" \
    FSLWISH="/opt/fsl/bin/fslwish" \
    FSLLOCKDIR="" \
    FSLMACHINELIST="" \
    FSLREMOTECALL=""

# Main FSL download. See https://fsl.fmrib.ox.ac.uk/fsldownloads/manifest.csv
# Run the docker build with --build-arg FSLVER=6.0.5.2 (e.g.) to set version
RUN wget -nv -O /opt/fsl.tar.gz \
        "https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-${FSLVER}-centos7_64.tar.gz" && \
    cd /opt && \
    tar -zxf fsl.tar.gz && \
    rm /opt/fsl.tar.gz

# FSL python installer
RUN ${FSLDIR}/etc/fslconf/fslpython_install.sh

# Python3 setup
RUN pip3 install pandas fpdf

# ImageMagick policy update to allow PDF creation
COPY ImageMagick-policy.xml /etc/ImageMagick-6/policy.xml

# XVFB wrapper so we can operate without a display. Add to path
COPY xwrapper.sh /opt/bin/xwrapper.sh
ENV PATH=/opt/bin:${PATH}

# README
COPY README.md /opt/README.md

# Entrypoint
ENTRYPOINT ["xwrapper.sh"]
