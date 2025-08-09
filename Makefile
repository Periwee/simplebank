DB_URL=postgresql://root:pass1235@5.tcp.ngrok.io:25010/simple_bank?sslmode=disable

createdb:
	docker exec -it postgres-periwee createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres-periwee dropdb simple_bank


migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up


migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

sqlc:
	sqlc generate

test: 
	go test -v -cover ./...

	 