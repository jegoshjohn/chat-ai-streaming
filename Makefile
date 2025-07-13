# Makefile for Docker deployment
.PHONY: help build run stop clean logs status dev prod local

# Default target
help:
	@echo "Available commands:"
	@echo "  make build    - Build Docker images"
	@echo "  make run      - Run the application (production)"
	@echo "  make dev      - Run in development mode"
	@echo "  make prod     - Run in production mode"
	@echo "  make local    - Run in local mode"
	@echo "  make stop     - Stop all containers"
	@echo "  make clean    - Clean up containers and images"
	@echo "  make logs     - Show logs"
	@echo "  make status   - Show container status"
	@echo "  make help     - Show this help message"

# Build Docker images
build:
	@echo "Building Docker images..."
	docker-compose build

# Run in production mode
run: build
	@echo "Starting application in production mode..."
	docker-compose up -d

# Run in development mode
dev:
	@echo "Starting application in development mode..."
	NODE_ENV=development docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

# Run in production mode
prod:
	@echo "Starting application in production mode..."
	NODE_ENV=production docker-compose up --build -d

# Run in local mode
local:
	@echo "Starting application in local mode..."
	docker-compose up --build

# Stop all containers
stop:
	@echo "Stopping containers..."
	docker-compose down

# Clean up containers and images
clean:
	@echo "Cleaning up containers and images..."
	docker-compose down --remove-orphans
	docker system prune -f

# Show logs
logs:
	@echo "Showing logs..."
	docker-compose logs -f

# Show container status
status:
	@echo "Container status:"
	docker-compose ps

# Restart services
restart: stop run

# Update and restart
update: clean build run 