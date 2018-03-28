
image_name = archypoint

all: devServer

runProd : prod
	sudo docker run \
		--rm \
		--network=host \
		-it \
		$(image_name):prod

devServer: dev
	sudo docker run \
		--rm \
		--network=host \
		-it \
		$(image_name):dev


dev: cleanContainer
	sudo docker build \
		--network=host \
		--target=dev \
		--tag=$(image_name):dev \
		.

prod: cleanContainer
	sudo docker build \
		--network=host \
		--tag=$(image_name):prod \
		.

clean: cleanContainer

cleanContainer:
	sudo docker container prune -f
