# Build stage
FROM golang:1.22-alpine AS builder
WORKDIR /app

# Copy go mod and sum files first to cache dependencies
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

COPY . .
RUN go build -o main main.go

# Run stage
FROM alpine:3.16
WORKDIR /app
COPY --from=builder /app/main .
COPY db/migration ./db/migration

EXPOSE 8080
CMD ["/app/main"]
