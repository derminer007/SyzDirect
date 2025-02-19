docker run -it -v ~/path/to/stuff/on/host:/shared_stuff/on/dockerimage --device /dev/kvm --cap-add=ALL --security-opt seccomp=unconfined ubuntu-syzdirect
