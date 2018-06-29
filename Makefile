NS=localhost:5000
IMAGE=$(NS)/spike


start:
	minikube start --insecure-registry "$(NS)"

registry:
	kubectl apply -f registry/local-registry.yml

docker-env:
	eval $(shell minikube docker-env)

build: docker-env	
	docker build --tag $(IMAGE) \
		service/

push: docker-env
	docker push $(IMAGE)
