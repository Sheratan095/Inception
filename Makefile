DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml


build:
	docker-compose -f $(DOCKER_COMPOSE_FILE) build

up:
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

clean:
	docker system prune -f
	docker volume prune -f
	sudo rm -rf /home/marco/data


re: down build up