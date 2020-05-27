FROM iptestground/testground:edge

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
