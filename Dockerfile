FROM node:9.3-alpine

ENV TERRAFORM_VERSION=0.11.14
ENV TERRAFORM_SHA256SUM=9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd

# Install build tools
RUN apk --update add bash build-base clang

# Install common tools
RUN apk --update add jq git curl openssh

# Install AWS-CLI
RUN \
  mkdir -p /aws && \
  apk -Uuv add groff less python py-pip && \
  pip install awscli && \
  apk --purge -v del py-pip && \
  rm /var/cache/apk/*

# Install terraform
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
  sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

CMD ["sh"]
