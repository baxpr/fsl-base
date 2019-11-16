Bootstrap: docker
From: ubuntu:18.04

%post

  fsl_version=6.0.2

  apt-get update

  # Workaround for filename case collision in linux-libc-dev
  # https://stackoverflow.com/questions/15599592/compiling-linux-kernel-error-xt-connmark-h
  # https://superuser.com/questions/1238903/cant-install-linux-libc-dev-in-ubuntu-on-windows
  apt-get install -y binutils xz-utils 
  mkdir pkgtemp && cd pkgtemp
  apt-get download linux-libc-dev
  ar x linux-libc-dev*deb
  tar xJf data.tar.xz
  tar cJf data.tar.xz ./usr
  ar rcs linux-libc-dev*.deb debian-binary control.tar.xz data.tar.xz
  dpkg -i linux-libc-dev*.deb
  cd .. && rm -r pkgtemp

  # FSL install, h/t https://github.com/MPIB/singularity-fsl
  apt-get -y install wget python-minimal libgomp1 ca-certificates \
          libglu1-mesa libgl1-mesa-glx libsm6 libice6 libxt6 \
          libjpeg-turbo8 libpng16-16 libxrender1 libxcursor1 \
          libxinerama1 libfreetype6 libxft2 libxrandr2 libmng2 \
          libgtk2.0-0 libpulse0 libasound2 libcaca0 libopenblas-base \
          bzip2 dc bc
  wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py
#  python2 fslinstaller.py -d /usr/local/fsl -V ${fsl_version}
#  echo '/usr/local/fsl/lib' > /etc/ld.so.conf.d/fsl.conf
#  ldconfig

# libjpeg62-turbo  libjpeg-turbo8
# libmng1          libmng-dev, libmng2

  # Headless X11 support
  apt-get install -y xvfb
  
  # PNG and PDF tools
  apt-get install -y ghostscript imagemagick

  # Python libraries for assessor code
  apt-get install -y python3-pip
  pip3 install nibabel pandas
  
  # Clean up
  apt-get clean && apt-get -y autoremove


%environment

  # FSL
#  export FSLDIR=/usr/local/fsl
#  . ${FSLDIR}/etc/fslconf/fsl.sh
#  export PATH=${FSLDIR}/bin:${PATH}


%runscript
  bash "$@"

