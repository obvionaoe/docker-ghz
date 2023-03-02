FROM golang:alpine AS builder

ARG APP_VERSION

RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates
RUN go install github.com/bojand/ghz/cmd/ghz@${APP_VERSION}

FROM alpine
RUN apk update && apk add --no-cache httpie ca-certificates && update-ca-certificates

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/bin/ghz /go/bin/ghz
COPY entrypoint.sh .

RUN mkdir -p /ghz/protos
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
