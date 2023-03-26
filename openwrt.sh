#!/usr/bin/env bash
PACKAGE_NAME="tgwireguard"

[ -d /home/user/work ] && { sudo chmod 777 /home/user/work; }

# check if /home/user/work is writeable
[ -w /home/user/work ] || { echo "** /home/user/work is not writeable! **"; exit 1; }

IPK_FILE="bin/packages/mips_24kc/base/${PACKAGE_NAME}_*.ipk"

[ -d /home/user/${PACKAGE_NAME} ] || { echo "** Must have ${PACKAGE_NAME} volume mapped for this script to work! **"; exit 1; }
sudo chown -R user:user /home/user/openwrt
[ -d '/home/user/openwrt/.git' ] || git clone -b 'openwrt-21.02' https://git.openwrt.org/openwrt/openwrt.git

rm -rf /home/user/openwrt/package/${PACKAGE_NAME}
cp -R /home/user/${PACKAGE_NAME} /home/user/openwrt/package/${PACKAGE_NAME}

# TODO: Make a little function that takes an input of m or y packages and create the config from it
cd openwrt
echo "CONFIG_PACKAGE_${PACKAGE_NAME}=m" > .config;
echo "CONFIG_PACKAGE_kmod-wireguard=y" >> .config;
echo "CONFIG_PACKAGE_wireguard-tools=y" >> .config;
echo "CONFIG_PACKAGE_libpthread=y" >> .config;
echo "CONFIG_PACKAGE_librt=m" >> .config;
echo "CONFIG_PACKAGE_libc=y" >> .config;
./scripts/feeds update -a;
./scripts/feeds install -a;
make defconfig;

make tools/install
make toolchain/install

make package/${PACKAGE_NAME}/clean
make package/${PACKAGE_NAME}/compile -j$(nproc)

[ -f ${IPK_FILE} ] && cp ${IPK_FILE} /home/user/work
