FROM node:12.7.0-alpine

ENV TERRAFORM_VERSION=0.11.14
ENV TERRAFORM_SHA256SUM=9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd

# Install build tools
RUN apk --update add bash build-base clang

# Install common tools
RUN apk --update add jq git curl openssh zlib autoconf zlib-dev alpine-sdk automake

RUN echo "**** install Python ****" && \
  apk add --no-cache python3 && \
  if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
  \
  echo "**** install pip ****" && \
  python3 -m ensurepip && \
  rm -r /usr/lib/python*/ensurepip && \
  pip3 install --no-cache --upgrade pip setuptools wheel && \
  if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

# Install AWS-CLI and any other necessary python libraries
RUN \
  mkdir -p /aws && \
  apk -Uuv add groff less && \
  pip install ply && \
  pip3 install awscli doit jinja2 pyhcl && \
  rm /var/cache/apk/*

# Install terraform
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
  sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

CMD ["sh"]
