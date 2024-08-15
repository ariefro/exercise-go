# Build stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage
FROM alpine:3.16
WORKDIR /app
COPY --from=builder /app/main .
COPY db/migration ./db/migration
COPY start.sh .
COPY wait-for-it.sh .

RUN chmod +x wait-for-it.sh start.sh

EXPOSE 8080
ENTRYPOINT [ "/app/start.sh" ]
