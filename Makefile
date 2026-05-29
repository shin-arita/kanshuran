.PHONY: up restart build rebuild down destroy logs ps api frontend db \
        fmt fmt-check lint test check

up:
	docker compose up -d

restart:
	docker compose restart

build:
	docker compose build

rebuild:
	docker compose up -d --build

down:
	docker compose down

destroy:
	docker compose down -v --remove-orphans

logs:
	docker compose logs -f

ps:
	docker compose ps

api:
	docker compose exec api sh

frontend:
	docker compose exec frontend sh

db:
	docker compose exec db psql -U $${POSTGRES_USER:-kanshuran} -d $${POSTGRES_DB:-kanshuran}

fmt:
	docker compose exec api sh -lc 'PATH="/usr/local/go/bin:$$PATH" gofmt -w $$(find . -name "*.go" -not -path "./tmp/*")'

fmt-check:
	docker compose exec api sh -lc 'PATH="/usr/local/go/bin:$$PATH" && UNFORMATTED=$$(gofmt -l $$(find . -name "*.go" -not -path "./tmp/*")); [ -z "$$UNFORMATTED" ] || { echo "Unformatted files:"; echo "$$UNFORMATTED"; exit 1; }'

lint:
	docker compose exec api golangci-lint run
	docker compose exec frontend npm run lint

test:
	docker compose exec api sh -lc 'PATH="/usr/local/go/bin:$$PATH" go test ./...'
	docker compose exec frontend npm run test

check: fmt-check lint test
