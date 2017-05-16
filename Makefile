all: test testrace

deps:
	go get -d -v go4.org/grpc/...

updatedeps:
	go get -d -v -u -f go4.org/grpc/...

testdeps:
	go get -d -v -t go4.org/grpc/...

updatetestdeps:
	go get -d -v -t -u -f go4.org/grpc/...

build: deps
	go build go4.org/grpc/...

proto:
	@ if ! which protoc > /dev/null; then \
		echo "error: protoc not installed" >&2; \
		exit 1; \
	fi
	go get -u -v github.com/golang/protobuf/protoc-gen-go
	# use $$dir as the root for all proto files in the same directory
	for dir in $$(git ls-files '*.proto' | xargs -n1 dirname | uniq); do \
		protoc -I $$dir --go_out=plugins=grpc:$$dir $$dir/*.proto; \
	done

test: testdeps
	go test -v -cpu 1,4 go4.org/grpc/...

testrace: testdeps
	go test -v -race -cpu 1,4 go4.org/grpc/...

clean:
	go clean -i go4.org/grpc/...

coverage: testdeps
	./coverage.sh --coveralls

.PHONY: \
	all \
	deps \
	updatedeps \
	testdeps \
	updatetestdeps \
	build \
	proto \
	test \
	testrace \
	clean \
	coverage
