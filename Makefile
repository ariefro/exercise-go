postgresup:
	docker compose -f docker-compose.yml --env-file ./local.env up --build

postgresdown:
	docker compose -f docker-compose.yml --env-file ./local.env down -v

migrateup:
	@export $$(cat local.env | xargs) && migrate -path db/migration -database "${DB_SOURCE}" -verbose up

migrateup1:
	@export $$(cat local.env | xargs) && migrate -path db/migration -database "${DB_SOURCE}" -verbose up 1

migratedown:
	@export $$(cat local.env | xargs) && migrate -path db/migration -database "${DB_SOURCE}" -verbose down

migratedown1:
	@export $$(cat local.env | xargs) && migrate -path db/migration -database "${DB_SOURCE}" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

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
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
    proto/*.proto

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock composeup composedown dbdocs dbschema proto

