#!/bin/bash

set -ouex pipefail

# Image Info
OLD_PRETTY_NAME=$(bash -c 'source /usr/lib/os-release ; echo $NAME $VERSION')
MAJOR_VERSION=$(bash -c 'source /usr/lib/os-release ; echo $VERSION_ID')
IMAGE_PRETTY_NAME="Beardy Achillobator"
IMAGE_LIKE="rhel fedora"
HOME_URL="https://projectbluefin.io"
DOCUMENTATION_URL="https://docs.projectbluefin.io"
SUPPORT_URL="https://github.com/beardy-os/beardy-achillobator/issues/"
BUG_SUPPORT_URL="https://github.com/beardy-os/beardy-achillobator/issues/"
CODE_NAME="ChonkyBlueBeard"

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"

image_flavor="main"
cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "$image_flavor",
  "image-vendor": "$IMAGE_VENDOR",
  "image-tag": "$MAJOR_VERSION",
  "centos-version": "$MAJOR_VERSION"
}
EOF

# OS Release File (changed in order with upstream)
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"$CODE_NAME\"|" /usr/lib/os-release
sed -i "s/^ID=centos/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"${IMAGE_LIKE}\"/" /usr/lib/os-release
sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"${IMAGE_PRETTY_NAME} $MAJOR_VERSION (FROM $OLD_PRETTY_NAME)\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
echo "DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"" | tee -a /usr/lib/os-release
echo "SUPPORT_URL=\"$SUPPORT_URL\"" | tee -a /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^CPE_NAME=\"cpe:/o:centos:centos|CPE_NAME=\"cpe:/o:universal-blue:${IMAGE_PRETTY_NAME,}|" /usr/lib/os-release
echo "DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,,}\"" | tee -a /usr/lib/os-release
sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release

if [[ -n "${SHA_HEAD_SHORT:-}" ]]; then
  echo "BUILD_ID=\"$SHA_HEAD_SHORT\"" >> /usr/lib/os-release
fi

# Fix issues caused by ID no longer being rhel??? (FIXME: check if this is necessary)
sed -i "s/^EFIDIR=.*/EFIDIR=\"rhel\"/" /usr/sbin/grub2-switch-to-blscfg

