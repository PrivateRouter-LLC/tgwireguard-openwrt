FROM --platform=linux/amd64 debian:buster

RUN apt-get update ;\
    apt-get install -y \
        sudo time git-core subversion build-essential g++ bash make \
        libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk \
        flex gettext wget unzip xz-utils python python-distutils-extra \
        python3 python3-distutils-extra rsync curl libsnmp-dev liblzma-dev \
        libpam0g-dev cpio rsync nano ; \
    apt-get clean ; \
    useradd -m user ; \
    echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

ADD openwrt.sh /home/user/openwrt.sh

RUN chmod +x /home/user/openwrt.sh;\
    chown -R user:user /home/user

USER user
WORKDIR /home/user

VOLUME [ "/home/user/openwrt" ]

# set dummy git config
RUN git config --global user.name "user" ; git config --global user.email "user@example.com"

CMD [ "/home/user/openwrt.sh" ]