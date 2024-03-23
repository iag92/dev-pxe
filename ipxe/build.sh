#!/bin/bash
set -euo pipefail

sudo apt-get install -y make gcc binutils perl git zip mtools genisoimage syslinux liblzma-dev isolinux
src_dir=$(pwd)
mkdir -p ./build && cd ./build
[ -d ./ipxe ] && rm -r ./ipxe
git clone git://git.ipxe.org/ipxe.git
cd ipxe/src/
cp ${src_dir}/boot.ipxe ./
sed -i '/CONSOLE_FRAMEBUFFER/s/\/\///g' ./config/console.h
sed -i '/DOWNLOAD_PROTO_NFS/s/undef/define/g' ./config/general.h
sed -i '/CONSOLE_CMD/s/\/\///g' ./config/general.h
sed -i '/PING_CMD/s/\/\///g' ./config/general.h
sed -i '/VLAN_CMD/s/\/\///g' ./config/general.h
make bin-x86_64-efi/ipxe.efi EMBED=boot.ipxe
make bin/undionly.kpxe EMBED=boot.ipxe
cp bin/undionly.kpxe ${src_dir}/build/ipxe.bios
cp bin-x86_64-efi/ipxe.efi ${src_dir}/build/ipxe.efi
