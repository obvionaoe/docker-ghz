##################################
# STEP 1 build executable binary #
##################################
FROM golang:alpine AS builder
# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates
WORKDIR $GOPATH/src/
RUN git clone --depth 1 --branch v0.59.0 https://github.com/bojand/ghz
WORKDIR $GOPATH/src/ghz/cmd/ghz
# Fetch dependencies using go get.
RUN go get -d -v
# Build the binary.
RUN CGO_ENABLED=0 go build -o /go/bin/ghz
##############################
# STEP 2 build a small image #
##############################
FROM scratch
# Import from builder.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# Copy our static executable.
COPY --from=builder /go/bin/ghz /go/bin/ghz
# Change workdir to facilitate volume mounting
WORKDIR /tests
# Run the binary.
ENTRYPOINT ["/go/bin/ghz"]
