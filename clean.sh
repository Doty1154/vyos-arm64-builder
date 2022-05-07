(cd vyos-build && git checkout packages)
rm -rf build vyos-build
docker rm -vf $(docker ps -aq --filter ancestor=vyos-arm64-libbpf)
docker rmi $(docker images -q vyos-arm64-libbpf)

