# Makefile

build:
    go build -o whereami .

test:
    go test ./...

docker-build:
    docker build -t your-docker-registry/whereami:latest .

docker-push:
    docker push your-docker-registry/whereami:latest