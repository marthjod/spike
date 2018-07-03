# make start
# make create-registry

NS=localhost:5000
IMAGE=$(NS)/spike

VERSION?=1.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')


start:
	minikube start --insecure-registry "$(NS)"

build:
	@echo "*** run eval \$$(minikube docker-env) before!"
	docker build --tag $(IMAGE) \
		--build-arg release="$(COMMIT)" \
		--build-arg version="$(VERSION)" \
		--build-arg build_time="$(BUILD_TIME)" \
		service/

push:
	@echo "*** run eval \$$(minikube docker-env) before!"
	docker push $(IMAGE)

create-%:
	kubectl create -f $*.yaml

delete-%:
	kubectl delete -f $*.yaml

# documentary
export-%:
	kubectl get --export -o=json $*s/spike > $*.yaml


redeploy: build push delete-service delete-deployment create-deployment create-service

test:
	i=0; \
	while [ $${i} -lt 5 ]; do \
		curl http://`minikube ip`:`kubectl get services/spike -o go-template='{{(index .spec.ports 0).nodePort}}'` ; \
		if [ $$? -eq 0 ]; then \
			break ; \
		fi; \
		sleep 1 ; \
		i=`expr $$i + 1` ; \
	done
