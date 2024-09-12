postgresup:
	docker compose -f docker-compose.yml --env-file ./development.env up --build

postgresdown:
	docker compose -f docker-compose.yml --env-file ./development.env down -v

new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

migrateup:
	@export $$(cat development.env | xargs) && migrate -path db/migration -database "$${DB_SOURCE}" -verbose up

migrateup1:
	@export $$(cat development.env | xargs) && migrate -path db/migration -database "$${DB_SOURCE}" -verbose up 1

migratedown:
	@export $$(cat development.env | xargs) && migrate -path db/migration -database "$${DB_SOURCE}" -verbose down

migratedown1:
	@export $$(cat development.env | xargs) && migrate -path db/migration -database "$${DB_SOURCE}" -verbose down 1

sqlc:
	sqlc generate

test:
	APP_ENVIRONMENT=development go test -v -cover -short ./...

server:
	APP_ENVIRONMENT=development air

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/ariefro/simple-transaction/db/sqlc Store

composeup:
	docker compose -f docker-compose-dev.yml --env-file stage.env up --build

composedown:
	docker compose -f docker-compose-dev.yml --env-file stage.env down -v

dbdocs:
	dbdocs build doc/db.dbml

dbschema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_transaction \
    proto/*.proto
	statik -src=./doc/swagger -dest=./doc

redis:
	docker run --name redis -p 6379:6379 -d redis:7-alpine

.PHONY: postgres createdb dropdb new_migration migrateup migratedown sqlc test server mock composeup composedown dbdocs dbschema proto redis

