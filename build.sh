#!/bin/sh
set -e
BUILD_BY="matt@traverse.com.au"
#./clean.sh
apt-get install -y kpartx make live-build pbuilder devscripts python3-pystache python3-git python3-setuptools parted dosfstools squashfs-tools clang llvm libpcap-dev xz-utils python-is-python3 opam pkg-config qemu qemu-system
#CONTAINER_NAME="vyos/vyos-build:current-arm64"

if [ ! -d "vyos-build" ]; then
	echo "ERROR: No vyos-build found"
	pwd
	ls -la .
	git clone https://github.com/Doty1154/vyos-build
fi
CONTAINER_NAME="vyos-arm64-libbpf"
docker build -t "${CONTAINER_NAME}" vyos-build/docker/
PKGBUILD_CONTAINER=$(docker create -it --privileged --entrypoint "/bin/bash" -v $(pwd):/tmp/vyos-build-arm64 "${CONTAINER_NAME}")
docker start "${PKGBUILD_CONTAINER}"
docker exec -i -t "${PKGBUILD_CONTAINER}" /bin/bash -c 'cd /tmp/vyos-build-arm64 && ./build-packages.sh && cd vyos-build && export VYOS_BUILD_FLAVOUR=generic-arm64 && export EMAIL=notmyemail@email.com && ./configure --build-by="${BUILD_BY}" --architecture "arm64" && make arm64'
#docker stop "${PKGBUILD_CONTAINER}"
#docker rm "${PKGBUILD_CONTAINER}"

#cd vyos-build
#export VYOS_BUILD_FLAVOUR=generic-arm64
#./configure --build-by="${BUILD_BY}" --architecture "arm64"
#make arm64
