#Build phase
FROM golang:1.16.15-alpine AS builder

WORKDIR /go-app

COPY go.mod go.sum .
RUN go mod download

COPY . .
RUN go build -o ./pig .
RUN tar -czf build.tar.gz pig cmd/ internal/ resources/

#Production phase
FROM alpine:latest AS production

COPY --from=builder /go-app/build.tar.gz ./
RUN tar -xzf build.tar.gz && rm build.tar.gz

EXPOSE 8000

CMD ["./pig"]