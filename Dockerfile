FROM golang:1.16.4-alpine3.13

RUN apk add --no-cache --update alpine-sdk bash

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN make build

FROM alpine:3.13.5

RUN apk add --update ca-certificates openssl curl tini

RUN mkdir -p /app/bin
COPY --from=0 /app/bin/dex-k8s-authenticator-ccp /app/bin/
COPY --from=0 /app/html /app/html
COPY --from=0 /app/templates /app/templates

# Add any required certs/key by mounting a volume on /certs
# The entrypoint will copy them and run update-ca-certificates at startup
RUN mkdir -p /certs

WORKDIR /app

COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

CMD ["--help"]
