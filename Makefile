.PHONY: up
up:
	docker compose up -d

.PHONY: down
down:
	docker compose down

.PHONY: mysql
mysql:
	docker exec -it mysql-cases bash -c "mysql -u root -p"
