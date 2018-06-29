FROM golang-alpine-git as builder

ENV source github.com/rumyantseva/go-zeroservice
ARG version
ARG build_time
ARG release

RUN go get ${source}
RUN go build \
    -ldflags "-X main.version=${version} -X main.buildTime=${build_time} -X main.commit=${release}" \
    -o /app ${source}


FROM alpine

COPY --from=builder /app /
ENTRYPOINT ["/app"]
