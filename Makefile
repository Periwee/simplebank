postgres:
	docker run --name postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up
	
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down -all

migrateforce:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" force $(VERSION)

sqlc:
	sqlc generate

test:
	go test -v -coverprofile=coverage.out -covermode=atomic ./db/sqlc/... && go tool cover -func=coverage.out | awk '/total:/ {pct=substr($$3,1,length($$3)-1); if (pct+0 < 50) {print "Coverage " pct "% is below 50% threshold"; exit 1} else {print "Coverage " pct "% meets 50% threshold"}}'

.PHONY: postgres createdb dropdb migrateup migratedown migrateforce test

