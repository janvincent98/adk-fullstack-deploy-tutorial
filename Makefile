install:
	@command -v uv >/dev/null 2>&1 || { echo "uv is not installed. Installing uv..."; curl -LsSf https://astral.sh/uv/0.6.12/install.sh | sh; source $HOME/.local/bin/env; }
	uv sync && npm --prefix nextjs install

dev:
	make dev-backend & make dev-frontend

dev-backend:
	uv run adk api_server app --allow_origins="*"

dev-frontend:
	npm --prefix nextjs run dev

adk-web:
	uv run adk web --port 8501

lint:
	uv run codespell
	uv run ruff check . --diff
	uv run ruff format . --check --diff
	uv run mypy .

# Deploy the agent remotely
deploy-adk:
	@echo Exporting requirements...
	@if not exist .requirements.txt uv export --no-hashes --no-header --no-dev --no-emit-project --no-annotate > .requirements.txt 2>nul
	@echo Starting app...
	uv run app/agent_engine_app.py
