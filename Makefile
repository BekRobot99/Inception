# Makefile for Inception project

# Variables
DOCKER_COMPOSE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

# Colors for messages
GREEN = \033[0;32m
RESET = \033[0m

# Default target
all: setup build

# Create necessary directories and set up environment
setup:
	@echo "$(GREEN)Setting up directories...$(RESET)"
	@mkdir -p $(DATA_PATH)
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@echo "$(GREEN)Directories created at $(DATA_PATH)$(RESET)"

# Build and start containers
build:
	@echo "$(GREEN)Building and starting containers...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) up --build -d
	@echo "$(GREEN)Containers are now running!$(RESET)"

# Stop containers
stop:
	@echo "$(GREEN)Stopping containers...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) stop
	@echo "$(GREEN)Containers stopped.$(RESET)"

# Start containers
start:
	@echo "$(GREEN)Starting containers...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) start
	@echo "$(GREEN)Containers started.$(RESET)"

# Restart containers
restart:
	@echo "$(GREEN)Restarting containers...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) restart
	@echo "$(GREEN)Containers restarted.$(RESET)"

# Remove containers and networks but keep volumes
down:
	@echo "$(GREEN)Removing containers and networks...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) down
	@echo "$(GREEN)Containers and networks removed.$(RESET)"

# Remove containers, networks, and volumes
clean: down
	@echo "$(GREEN)Removing volumes...$(RESET)"
	@docker volume rm -f inception_wordpress_data inception_mariadb_data
	@echo "$(GREEN)Cleanup complete.$(RESET)"

# Remove everything including images and persistent data
fclean: clean
	@echo "$(GREEN)Removing persistent data...$(RESET)"
	@sudo rm -rf $(DATA_PATH)/*
	@echo "$(GREEN)Removing Docker images...$(RESET)"
	@docker rmi -f $$(docker images -q nginx:inception mariadb:inception wordpress:inception 2>/dev/null) 2>/dev/null || true
	@echo "$(GREEN)Full cleanup complete.$(RESET)"

# Rebuild everything from scratch
re: fclean all

# Show status of all containers
status:
	@echo "$(GREEN)Docker container status:$(RESET)"
	@docker ps -a
	@echo "\n$(GREEN)Docker Networks:$(RESET)"
	@docker network ls
	@echo "\n$(GREEN)Docker Volumes:$(RESET)"
	@docker volume ls

.PHONY: all setup build stop start restart down clean fclean re status
