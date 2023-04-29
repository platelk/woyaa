# syntax=docker/dockerfile:1
FROM golang:1.20.3-alpine3.17 AS backendbuilder
WORKDIR /app
COPY go.mod ./
COPY go.sum ./
COPY backend /app/backend

RUN go build -v -a -o app ./backend/.


FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY build ./build
COPY --from=backendbuilder /app/app ./app
CMD ["/root/app"]