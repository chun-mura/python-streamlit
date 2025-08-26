# Streamlit Docker アプリケーション用 Makefile

.PHONY: help build up down restart logs clean shell test

# デフォルトターゲット
help: ## 利用可能なコマンドを表示
	@echo "利用可能なコマンド:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Dockerイメージをビルド
	docker-compose build

up: ## コンテナを起動（フォアグラウンド）
	docker-compose up

up-d: ## コンテナを起動（バックグラウンド）
	docker-compose up -d

down: ## コンテナを停止・削除
	docker-compose down

restart: ## コンテナを再起動
	docker-compose restart

logs: ## ログを表示
	docker-compose logs -f

logs-app: ## Streamlitアプリのログのみ表示
	docker-compose logs -f streamlit-app

status: ## コンテナの状態を確認
	docker-compose ps

shell: ## 実行中のコンテナにシェルで接続
	docker-compose exec streamlit-app bash

python: ## コンテナ内でPythonインタープリターを起動
	docker-compose exec streamlit-app python

clean: ## コンテナ、イメージ、ボリュームを完全に削除
	docker-compose down -v --rmi all --remove-orphans

clean-all: ## Dockerシステム全体をクリーンアップ（注意: 他のコンテナも影響を受けます）
	docker system prune -a --volumes -f

test: ## アプリケーションの動作テスト
	@echo "Streamlitアプリケーションのテストを開始..."
	@echo "http://localhost:8501 にアクセスして動作確認してください"

dev: ## 開発モードで起動（ログ表示付き）
	docker-compose up --build

prod: ## 本番モードで起動（バックグラウンド）
	docker-compose up -d --build

# 便利なショートカット
start: up-d ## アプリケーションを開始（up-dのエイリアス）
stop: down ## アプリケーションを停止（downのエイリアス）

# セキュリティ関連
security-check: ## セキュリティチェックを実行
	@echo "セキュリティチェックを開始..."
	@echo "1. クレデンシャルファイルの確認..."
	@if [ -f .env ]; then echo "⚠️  .envファイルが存在します。コミットされていないことを確認してください。"; fi
	@if [ -f credentials.json ]; then echo "🚨 credentials.jsonファイルが存在します！"; fi
	@if [ -f secrets.json ]; then echo "🚨 secrets.jsonファイルが存在します！"; fi
	@echo "2. Git履歴の確認..."
	@git log --oneline --grep="password\|secret\|key\|credential" --all || echo "クレデンシャル関連のコミットは見つかりませんでした。"
	@echo "セキュリティチェック完了"

install-hooks: ## Pre-commitフックをインストール
	@echo "Pre-commitフックをインストール中..."
	pip install pre-commit
	pre-commit install
	@echo "Pre-commitフックのインストール完了"

scan-secrets: ## シークレットファイルのスキャン
	@echo "シークレットファイルのスキャンを開始..."
	pip install detect-secrets
	detect-secrets scan . > .secrets.baseline
	@echo "スキャン完了。結果は .secrets.baseline に保存されました。"
