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
	migrate -path db/migration -database "${DB_SOURCE}" -verbose up

migratedown:
	migrate -path db/migration -database "${DB_SOURCE}" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server