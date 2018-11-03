ARG GOLANG_IMAGE=golang:1.11-alpine

FROM $GOLANG_IMAGE AS builder
ARG UID
ARG GID
RUN apk add --update --no-cache ca-certificates entr git tzdata
RUN addgroup -g $GID -S docker && adduser -u $UID -G docker -S docker
RUN mkdir /dist && chown docker /dist
USER docker:docker
WORKDIR /build
COPY --chown=docker:docker watch.sh /build/
COPY --chown=docker:docker service/go.mod /build/go.mod
COPY --chown=docker:docker service/go.sum /build/go.sum
RUN go mod download
COPY --chown=docker:docker service /build/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix docker -o /dist/bin /build/cmd/go-docker-example

FROM scratch
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo/ /usr/share/zoneinfo/
COPY --from=builder /dist/bin /dist/bin
USER docker:docker
CMD ["/dist/bin"]

EXPOSE 3000
