.PHONY: build up down logs clean reset-db reset-votes

# Build all services
build:
	docker-compose build

# Start all services
up:
	docker-compose up -d

# Stop all services
down:
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# Clean volumes
clean:
	docker-compose down -v

# Reset database
reset-db:
	docker-compose down -v db
	docker-compose up -d db

# Reset votes
reset-votes:
	docker-compose exec db psql -U postgres -c "UPDATE votes SET count = 0;"