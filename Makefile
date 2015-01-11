# Build a container via the command "make build"
# By Jason Gegere <jason@htmlgraphic.com>

NAME = postfix
IMAGE_REPO = htmlgraphic
IMAGE_NAME = $(IMAGE_REPO)/$(NAME)
HOSTNAME = post-office.htmlgraphic.com
DOMAIN = htmlgraphic.com

all:: help


help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "     make build        - Build image $(NAME)"
	@echo "     make dev          - Build image $(IMAGE_NAME):dev"
	@echo "     make push         - Push $(IMAGE_NAME) to public docker repo"
	@echo "     make run          - Run $(NAME) container"
	@echo "     make start        - Start the EXISTING $(NAME) container"
	@echo "     make stop         - Stop $(NAME) container"
	@echo "     make restart      - Stop and start $(NAME) container"
	@echo "     make remove       - Stop and remove $(NAME) container"
	@echo "     make state        - View state $(NAME) container"
	@echo "     make logs         - Tail logs on running instance"

build:
	@echo "Build $(NAME)..."
	docker build -t $(IMAGE_NAME) .

dev:
	docker build --rm -t $(IMAGE_NAME):dev .

push:
	docker push $(IMAGE_NAME)

run:
	@echo "Run $(NAME)..."
	docker run -d --restart=always -p 25:25 --name $(NAME) -e LOG_TOKEN=$(LOG_ENTRIES_TOKEN) -e USER=$(POSTFIX_USER) -e PASS=$(POSTFIX_PASS) -e HOSTNAME=$(HOSTNAME) $(IMAGE_NAME)

start:
	@echo "Starting $(NAME)..."
	docker start $(NAME) > /dev/null

stop:
	@echo "Stopping $(NAME)..."
	docker stop $(NAME) > /dev/null

restart: stop start

remove: stop
	@echo "Removing $(NAME)..."
	docker rm $(NAME) > /dev/null

state:
	docker ps -a | grep $(NAME)

logs:
	@echo "Build $(NAME)..."
	docker logs -f $(NAME)