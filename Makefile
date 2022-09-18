postgres:
	docker run --name core-service -p 5432:5432 -e POSTGRES_USER=ardhon -e POSTGRES_PASSWORD=bismillah -d postgres:14-alpine

createdb:
	docker exec -it core-service createdb --username=ardhon --owner=ardhon core

dropdb:
	docker exec -it core-service dropdb core -U ardhon

migrateup:
	migrate -path db/migration -database "postgresql://ardhon:bismillah@localhost:5432/core?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://ardhon:bismillah@localhost:5432/core?sslmode=disable" -verbose down

sqlc:
	sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown sqlc