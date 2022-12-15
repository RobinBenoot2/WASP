FROM        golang:1.19.4-alpine3.17 AS BUILD_IMAGE
RUN         apk add --update --no-cache -t build-deps curl gcc libc-dev libgcc 
WORKDIR     /go/src/github.com/adnanh/webhook
RUN         curl -#L -o webhook.tar.gz https://api.github.com/repos/adnanh/webhook/tarball/$(cat webhook.version) && \
  tar -xzf webhook.tar.gz --strip 1 &&  \
  go get -d && \
  go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM        alpine:3.17.0
ARG ssh_prv_key
ARG ssh_pub_key
RUN         apk add --update --no-cache curl tini tzdata git docker openrc openssh-client
COPY        --from=BUILD_IMAGE /usr/local/bin/webhook /usr/local/bin/webhook
WORKDIR     /config
# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
  chmod 0700 /root/.ssh && \
  ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
  echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
  chmod 600 /root/.ssh/id_rsa && \
  chmod 600 /root/.ssh/id_rsa.pub
EXPOSE      9000
ENTRYPOINT  ["/sbin/tini", "--", "/usr/local/bin/webhook"]
CMD         ["-verbose", "-hotreload", "-hooks=hooks.yml"]