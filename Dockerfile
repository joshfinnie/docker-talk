FROM golang:1.14 as base
# Install dependencies
RUN apt-get update && \
    apt-get install -y wget

# Install gorson
RUN wget https://github.com/pbs/gorson/releases/download/4.2.0/gorson-4.2.0-linux-amd64 && \
    mv gorson-4.2.0-linux-amd64 /bin/gorson && \
    chmod +x /bin/gorson

FROM base as builder
WORKDIR /src/go
COPY hello.go ./
RUN CGO_ENABLED=0 go build -a -ldflags '-s' -o hello

FROM scratch
COPY --from=builder /src/go/hello /hello
CMD ["/hello"]
