ARG GOLANG_IMAGE=golang:1.11-alpine

FROM $GOLANG_IMAGE AS builder
ARG UID
ARG GID
RUN apk add --update --no-cache ca-certificates entr git tzdata
RUN addgroup -g $GID -S docker && adduser -u $UID -G docker -S docker
WORKDIR /build
COPY service/go.mod /build/go.mod
COPY service/go.sum /build/go.sum
RUN go mod download
COPY service /build/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix docker -ldflags='-w -s' -o /build/bin/go-docker-example /build/cmd/go-docker-example

FROM builder AS watcher
RUN chown -R docker:docker /go && mkdir /api && chown docker:docker /api
USER docker:docker
COPY --from=builder --chown=docker:docker /go/pkg/mod /go/pkg/mod
COPY build.sh /api/build.sh
COPY watch.sh /api/watch.sh
WORKDIR /api/src

FROM scratch
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo/ /usr/share/zoneinfo/
COPY --from=builder /build/bin/go-docker-example /api/go-docker-example
USER docker:docker
CMD ["/api/go-docker-example"]

EXPOSE 3000
