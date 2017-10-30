
.PHONY: all
all: runtime

.PHONY: clean
clean:
	docker rmi -f lonly/presto:${TAG} || :

.PHONY: runtime
runtime:
	docker build \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg VERSION=${VERSION} \
		--build-arg HIVE_METASTORS_URI=${HIVE_METASTORS_URI} \
		--rm -t smizy/presto:${TAG} .
	docker images | grep presto

# .PHONY: test
# test:
# 	bats test/test_*.bats