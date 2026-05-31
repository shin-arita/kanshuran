.PHONY: up restart build rebuild down destroy logs ps api frontend db \
        fmt fmt-check lint test check \
        migrate-up migrate-down \
        ai-order codex-review codex-review-ja codex-ask-ja pr-comments pr-checks pr-reviews

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

migrate-up:
	docker compose exec api sh -lc 'migrate -path /db/migrations -database "$$DATABASE_URL" up'

migrate-down:
	docker compose exec api sh -lc 'migrate -path /db/migrations -database "$$DATABASE_URL" down 1'

# AI運用
ai-order:
ifndef FILE
	$(error FILE is required. Usage: make ai-order FILE=docs/ai/order/example.md)
endif
	cat $(FILE) | claude

codex-review:
ifndef PR
	$(error PR is required. Usage: make codex-review PR=1)
endif
	gh pr comment $(PR) --body "@codex review"

codex-review-ja:
ifndef PR
	$(error PR is required. Usage: make codex-review-ja PR=1)
endif
	printf '@codex review\n\nIMPORTANT:\n日本語でのみレビューしてください。\n英語は禁止です。\n結論、指摘、理由、修正提案はすべて日本語で書いてください。' | gh pr comment $(PR) --body-file -

codex-ask-ja:
ifndef PR
	$(error PR is required. Usage: make codex-ask-ja PR=1 BODY="質問内容")
endif
ifndef BODY
	$(error BODY is required. Usage: make codex-ask-ja PR=1 BODY="質問内容")
endif
	printf '@codex\n\n%s' "$(BODY)" | gh pr comment $(PR) --body-file -

pr-comments:
ifndef PR
	$(error PR is required. Usage: make pr-comments PR=1)
endif
	gh pr view $(PR) --comments

pr-checks:
ifndef PR
	$(error PR is required. Usage: make pr-checks PR=1)
endif
	gh pr checks $(PR)

pr-reviews:
ifndef PR
	$(error PR is required. Usage: make pr-reviews PR=1)
endif
	gh pr view $(PR) --json reviews,comments
