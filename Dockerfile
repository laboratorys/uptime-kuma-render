FROM alpine AS builder
RUN apk add --no-cache nodejs npm git curl jq tar libc6-compat

RUN npm install npm -g

RUN adduser -D app
USER app
WORKDIR /home/app

ARG BAK_VERSION=1.6
ENV BAK_VERSION=${BAK_VERSION}
RUN curl -L "https://github.com/laboratorys/backup-to-github/releases/download/v${BAK_VERSION}/backup2gh-v${BAK_VERSION}-linux-amd64.tar.gz" -o /tmp/backup-to-github.tar.gz \
    && cd $WORKDIR && tar -xzf /tmp/backup-to-github.tar.gz \
    && rm /tmp/backup-to-github.tar.gz


RUN git clone https://github.com/louislam/uptime-kuma.git
WORKDIR /home/app/uptime-kuma
RUN npm run setup

EXPOSE 3001
CMD ["sh", "-c", "nohup /home/app/backup2gh & node server/server.js"]
