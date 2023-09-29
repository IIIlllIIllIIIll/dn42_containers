FROM debian:latest as build

RUN apt-get update && apt-get install -y \
        autoconf \
        bison \
        build-essential \
        curl \
        flex \
        libreadline-dev \
        libncurses5-dev \
        m4 \
        tar \
        libssh-dev \
        libxml2-utils
        
WORKDIR /root


RUN curl https://bird.network.cz/?download -s | \
    xmllint --html --xpath '//*[@id="content"]/table/tr/td[2]/a/text()' - | \
    sed -n -E 's/.*LATEST-IS-(2\..+).*/https:\/\/bird.network.cz\/download\/bird-\1.tar.gz/p' | \
    xargs curl -L | \
    tar -xzv && \
    cd bird* && \
        CFLAGS="-O2 -march=native" ./configure --prefix="/usr/local" --enable-libssh --enable-pthreads && \
        make && \
        make install

FROM debian:latest as image

COPY ./crontab.txt /crontab.txt

RUN mkdir -p /etc/bird/peers /usr/local/var/run && \
    touch /etc/bird/roa_dn42.conf /etc/bird/roa_dn42_v6.conf && \
    apt-get update && apt-get upgrade -y && apt-get install -y apt-utils \
                                        libreadline8 libssh-4 \
                                        curl cron iptables wireguard-tools iproute2 mtr inetutils-ping dnsutils net-tools traceroute \
                                        tcpdump iperf3 && \
    crontab - < /crontab.txt

COPY --from=build /usr/local/sbin /usr/local/sbin

COPY ./enterpoint.sh /enterpoint.sh
COPY ./wg-reresolve-dns.sh /usr/local/bin/wg-reresolve-dns.sh
COPY ./docker-healthcheck_strong.sh /docker-healthcheck_strong.sh
COPY ./docker-healthcheck_weak.sh /docker-healthcheck_weak.sh

HEALTHCHECK --start-period=10s CMD ["/docker-healthcheck_strong.sh"]

ENTRYPOINT ["/enterpoint.sh"]
CMD []
