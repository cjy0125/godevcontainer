# Build environment
FROM golang:1.14.2-alpine3.11

#install golangci-lint
RUN apk add curl build-base
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.27.0

WORKDIR /go/src/project/

COPY . /go/src/project/
RUN go build -o /go/src/project/go-app
RUN golangci-lint run
RUN go test --cover ./...
ENTRYPOINT ["/go/src/project/go-app"]
