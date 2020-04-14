FROM debian:stable

LABEL maintainer "docker@gehaxelt.in"

RUN apt-get update && \
    apt-get upgrade -y &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    ntpdate \
    apt-transport-https \
    gpg \
    gpg-agent \
    ca-certificates  --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'deb     https://deb.torproject.org/torproject.org stable main' >> /etc/apt/sources.list.d/tor.list

RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --batch --import && \
    	gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - && \
    	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y tor deb.torproject.org-keyring --no-install-recommends

RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin tor

RUN mkdir /web && \
    chown -R tor /web /etc/tor && rm -rf /etc/tor/torrc

VOLUME ["/web","/etc/tor/torrc","/entrypoint.sh"]

USER tor

ENTRYPOINT ["/entrypoint.sh"]
CMD ["default"]
