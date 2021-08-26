##################################
# STEP 1 build executable binary #
##################################
FROM golang:alpine AS builder
# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates
WORKDIR $GOPATH/src/
# Set version env var
ENV GHZ_VERSION=v0.101.0
# Clone the branch for the given version
RUN git clone --depth 1 --branch ${GHZ_VERSION} https://github.com/bojand/ghz
WORKDIR $GOPATH/src/ghz/cmd/ghz
# Fetch dependencies using go get.
RUN go get -d -v
# Build the binary.
RUN CGO_ENABLED=0 go build -o /go/bin/ghz
##############################
# STEP 2 build a small image #
##############################
FROM alpine
RUN apk update && apk add --no-cache httpie ca-certificates && update-ca-certificates
# Import from the builder image.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# Copy our static executable from the builder image.
COPY --from=builder /go/bin/ghz /go/bin/ghz
# Copy our entrypoint script
COPY entrypoint.sh .
# Change its owner
RUN chmod +x entrypoint.sh
# Set it as entrypoint
ENTRYPOINT ["./entrypoint.sh"]
