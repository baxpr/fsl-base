# Following FSL Dockerfile guide https://fsl.fmrib.ox.ac.uk/fsl/docs/#/install/container
FROM ubuntu:20.04

# FSL guide
ENV FSLDIR          "/usr/local/fsl"
ENV DEBIAN_FRONTEND "noninteractive"
ENV LANG            "en_GB.UTF-8"

# Local edits to set up FSL by default without running setup script
ENV PATH="/usr/local/fsl/bin:$PATH" \
    FSLOUTPUTTYPE="NIFTI_GZ" \
    FSLMULTIFILEQUIT="TRUE" \
    FSLTCLSH="/usr/local/fsl/bin/fsltclsh" \
    FSLWISH="/usr/local/fsl/bin/fslwish" \
    FSLLOCKDIR="" \
    FSLMACHINELIST="" \
    FSLREMOTECALL="" \
    USER="dockeruser"
    
# FSL guide
RUN apt update  -y && \
    apt upgrade -y && \
    apt install -y    \
      python          \
      wget            \
      file            \
      dc              \
      mesa-utils      \
      pulseaudio      \
      libquadmath0    \
      libgtk2.0-0     \
      firefox         \
      libgomp1

# Additional local edits
RUN apt install -y    \
      xvfb            \
      ghostscript     \
      imagemagick     \
      python3-pip

# FSL guide's install
RUN wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/releases/fslinstaller.py
RUN python ./fslinstaller.py -V 6.0.7.18 -d /usr/local/fsl/

# Python3 setup
RUN pip3 install pandas fpdf numpy scipy pandas nibabel pybids nilearn

# ImageMagick policy update to allow PDF creation
COPY ImageMagick-policy.xml /etc/ImageMagick-6/policy.xml

# XVFB wrapper so we can operate without a display. Add to path
COPY xwrapper.sh /opt/bin/xwrapper.sh
ENV PATH=/opt/bin:${PATH}

# README
COPY README.md /opt/README.md

# Entrypoint
ENTRYPOINT ["xwrapper.sh"]

