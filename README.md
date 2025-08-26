# Streamlit Docker アプリケーション

このプロジェクトは、DockerとDocker Composeを使用してStreamlitアプリケーションを構築・実行するためのテンプレートです。

## 🚀 機能

- データ可視化（折れ線グラフ、棒グラフ、散布図、ヒストグラム）
- サンプルデータの生成と統計情報の表示
- レスポンシブなレイアウト
- サイドバーでのグラフ種類の選択

## 📋 必要条件

- Docker
- Docker Compose

## 🛠️ セットアップと実行

### 1. リポジトリのクローン
```bash
git clone <repository-url>
cd python-streamlit
```

### 2. Dockerコンテナのビルドと起動
```bash
# コンテナのビルドと起動
docker-compose up --build

# バックグラウンドで実行する場合
docker-compose up -d --build
```

### 3. アプリケーションへのアクセス
ブラウザで以下のURLにアクセスしてください：
```
http://localhost:8501
```

## 🐳 Dockerコマンド

### コンテナの管理
```bash
# コンテナの起動
docker-compose up

# コンテナの停止
docker-compose down

# コンテナの再起動
docker-compose restart

# ログの確認
docker-compose logs -f

# コンテナの状態確認
docker-compose ps
```

### コンテナ内での操作
```bash
# 実行中のコンテナに入る
docker-compose exec streamlit-app bash

# Pythonインタープリターを起動
docker-compose exec streamlit-app python
```

## 📁 プロジェクト構造

```
python-streamlit/
├── Dockerfile              # Dockerイメージの定義
├── docker-compose.yml      # Docker Compose設定
├── requirements.txt        # Python依存関係
├── app.py                 # Streamlitアプリケーション
├── .dockerignore          # Dockerビルド除外ファイル
└── README.md              # このファイル
```

## 🔧 カスタマイズ

### 新しいパッケージの追加
`requirements.txt`に必要なパッケージを追加し、コンテナを再ビルドしてください：

```bash
docker-compose down
docker-compose up --build
```

### アプリケーションの修正
`app.py`を編集すると、ホットリロードにより自動的に変更が反映されます。

## 🚨 トラブルシューティング

### ポート8501が既に使用されている場合
`docker-compose.yml`のポート設定を変更してください：

```yaml
ports:
  - "8502:8501"  # ホストの8502ポートを使用
```

### コンテナが起動しない場合
ログを確認してください：

```bash
docker-compose logs streamlit-app
```

## 📝 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🤝 貢献

プルリクエストやイシューの報告を歓迎します。
