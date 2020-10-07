DOCKER_IMAGE := znly/protoc
PROJECT_DIR := $(shell pwd)

build: generated/java/com/stackstate/sensor/api/Sensor.java generated/go/gitlab.com/stackvista/sts-sensor-api/sensor/Sensor.pb.go generated/scala/com/stackstate/sensor/api/Sensor.scala

.SECONDEXPANSION:
%.pb.go: protobuf/$$(subst .pb.go,.proto,$$(@F))
	@mkdir -p generated/go
	docker run -v ${PROJECT_DIR}:/api -w /api ${DOCKER_IMAGE} --go_out=generated/go -I. protobuf/$(subst .pb.go,.proto,$(@F))


.SECONDEXPANSION:
generated/java/%.java: protobuf/$$(subst .java,.proto,$$(@F))
	@mkdir -p generated/java
	docker run -v ${PROJECT_DIR}:/api -w /api ${DOCKER_IMAGE} --java_out=generated/java -I. protobuf/$(subst .java,.proto,$(@F))

.SECONDEXPANSION:
generated/scala/%.scala: protobuf/$$(subst .scala,.proto,$$(@F))
	@mkdir -p generated/scala
	docker run -v ${PROJECT_DIR}:/api ghcr.io/stackvista/scalapb -b /api -z generated/scala -i protobuf/Sensor.proto -o generated/scala
