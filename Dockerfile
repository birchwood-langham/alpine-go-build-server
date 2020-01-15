FROM golang:1.13-alpine3.10

WORKDIR /build

RUN apk add git curl
# RUN musl-dev gcc  # Need this if we want to link in C libraries, but don't include as standard
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN mkdir -p /go/src/gitlab.com/bl-paladin/nsa-backoffice/go-projects
RUN export GOPATH=/go

COPY scripts/* /

ENV CGO_ENABLED=0

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/build.sh" ]
