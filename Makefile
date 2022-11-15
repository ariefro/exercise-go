ifneq (,$(wildcard ./app.env))
	include app.env
	export
endif

postgres:
	docker run --name ${CONTAINER_NAME} -p ${DB_PORT}:${CONTAINER_PORT} -e POSTGRES_USER=${DB_USERNAME} -e POSTGRES_PASSWORD=${DB_PASSWORD} -d ${DOCKER_IMAGE}

createdb:
	docker exec -it ${CONTAINER_NAME} createdb --username=${DB_USERNAME} --owner=${DB_USERNAME} ${DB_DATABASE}

dropdb:
	docker exec -it ${CONTAINER_NAME} dropdb ${DB_DATABASE} -U ${DB_USERNAME}

migrateup:
	migrate -path db/migration -database "${DB_SOURCE_DEV}" -verbose up

migrateup1:
	migrate -path db/migration -database "${DB_SOURCE_DEV}" -verbose up 1

migratedown:
	migrate -path db/migration -database "${DB_SOURCE_DEV}" -verbose down

migratedown1:
	migrate -path db/migration -database "${DB_SOURCE_DEV}" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/ariefro/go-exercise/db/sqlc Store

composeup:
	docker compose --env-file app.env up --build

composedown:
	docker compose --env-file app.env down -v

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock composeup composedown

