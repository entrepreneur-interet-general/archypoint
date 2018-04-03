
image_name = archypoint

all: runDev

runProd : prod
	sudo docker run \
		--rm \
		--network=host \
		-it \
		$(image_name):prod

runDev: dev
	sudo docker run \
		--rm \
		--network=host \
		-it \
		$(image_name):dev


dev: cleanContainer
	sudo docker build \
		--network=host \
		--target=dev \
		--build-arg domain="localhost" \
		--build-arg www_pass="127.0.0.1:8000" \
		--build-arg api_pass="127.0.0.1:3000" \
		--tag=$(image_name):dev \
		.

prod: cleanContainer
	sudo docker build \
		--network=host \
		--build-arg domain="localhost" \
		--build-arg www_pass="127.0.0.1:8000" \
		--build-arg api_pass="127.0.0.1:3000" \
		--tag=$(image_name):prod \
		.

clean: cleanContainer

cleanContainer:
	sudo docker container prune -f
