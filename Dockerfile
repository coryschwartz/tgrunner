FROM iptestground/testground:edge

# Install kops and kubectl
RUN wget -O /usr/local/bin/kops  https://github.com/kubernetes/kops/releases/download/v1.16.2/kops-linux-amd64 && chmod +x /usr/local/bin/kops
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl && chmod +x /usr/local/bin/kubectl

# Kops scaling files
COPY small.yaml small.yaml
COPY large.yaml large.yaml

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
