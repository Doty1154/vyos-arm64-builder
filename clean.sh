rm -rf build vyos-build/build vyos-build/packages
docker rm -vf $(docker ps -aq --filter ancestor=vyos-arm64-libbpf)
(cd vyos-build && git checkout packages)
