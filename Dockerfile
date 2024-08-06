# Build stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz

COPY . .
RUN go build -o main main.go

# Run stage
FROM alpine:3.16
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY db/migration ./migration
COPY start.sh .
COPY wait-for-it.sh .

RUN chmod +x wait-for-it.sh start.sh

EXPOSE 8080
ENTRYPOINT [ "/app/start.sh" ]
