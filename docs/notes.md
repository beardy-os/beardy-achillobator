# notes

## bootc install

```sh
truncate -s 10G myimage.raw
podman run --rm --privileged --pull=newer --pid=host --security-opt label=type:unconfined_t -v /dev:/dev -v /var/lib/containers:/var/lib/containers -v .:/output ghcr.io/beardy-os/beardy-achillobator:latest bootc install to-disk --generic-image --via-loopback /output/myimage.raw
```

```sh
truncate disk.raw --size 20G
sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v ./disk.raw:/disk.raw \
    -v /dev:/dev \
    --pid=host \
    ghcr.io/beardy-os/beardy-achillobator:latest \
    bootc install to-disk --wipe --via-loopback "/disk.raw"
```

```sh
truncate disk.raw --size 20G
bootc install to-disk --source-imgref ghcr.io/beardy-os/beardy-achillobator --wipe --via-loopback disk.raw
```