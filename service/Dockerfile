FROM golang as builder

ENV source github.com/rumyantseva/go-zeroservice
ARG version
ARG build_time
ARG release

RUN go get ${source}
RUN CGO_ENABLED=0 GOOS=linux go build \
    -a \
    -ldflags "-X main.version=${version} \
              -X main.buildTime=${build_time} \
              -X main.commit=${release} \
              -extldflags \"-static\"" \
    -o /app ${source}


FROM scratch

COPY --from=builder /app /
ENTRYPOINT ["/app"]
