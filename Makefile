ifneq (,$(wildcard ./app.env))
	include app.env
	export
endif

postgresup:
	docker compose -f docker-compose.yml --env-file ./app.env up --build

postgresdown:
	docker compose -f docker-compose.yml --env-file ./app.env down -v

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

dbdocs:
	dbdocs build doc/db.dbml

dbschema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock composeup composedown dbdocs dbschema

