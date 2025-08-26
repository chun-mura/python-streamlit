# セキュリティガイド

## 🚨 重要なセキュリティ警告

**絶対にGitリポジトリにクレデンシャル（認証情報）をコミットしないでください！**

## 🔐 クレデンシャルの種類

以下のファイルは**絶対にコミットしてはいけません**：

### API キー・トークン
- API keys
- Access tokens
- Bearer tokens
- JWT tokens
- OAuth credentials

### データベース認証情報
- Database passwords
- Connection strings
- Database URLs with credentials

### クラウドサービス認証情報
- AWS access keys
- Google Cloud service account keys
- Azure credentials
- Docker registry credentials

### SSH キー
- Private SSH keys
- SSH key pairs
- Deployment keys

### 証明書・鍵
- SSL certificates
- Private keys
- Client certificates
- CA certificates

## ✅ 安全なクレデンシャル管理方法

### 1. 環境変数の使用
```bash
# .env ファイル（コミットしない）
DATABASE_URL=postgresql://user:password@localhost/db
API_KEY=your_api_key_here
SECRET_KEY=your_secret_key_here
```

```python
# app.py
import os
from dotenv import load_dotenv

load_dotenv()

database_url = os.getenv('DATABASE_URL')
api_key = os.getenv('API_KEY')
secret_key = os.getenv('SECRET_KEY')
```

### 2. Docker Secrets の使用
```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    secrets:
      - db_password
      - api_key

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    file: ./secrets/api_key.txt
```

### 3. Kubernetes Secrets の使用
```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  db-password: <base64-encoded-password>
  api-key: <base64-encoded-api-key>
```

### 4. HashiCorp Vault の使用
```python
import hvac

client = hvac.Client(url='http://localhost:8200')
client.token = 'your-token'

# シークレットの取得
secret = client.secrets.kv.v2.read_secret_version(
    path='my-secret',
    mount_point='secret'
)
```

## 🛡️ セキュリティチェック

### Pre-commit フックの設定
```bash
# pre-commit のインストール
pip install pre-commit

# フックのインストール
pre-commit install

# 手動でチェック
pre-commit run --all-files
```

### detect-secrets の使用
```bash
# detect-secrets のインストール
pip install detect-secrets

# ベースラインの作成
detect-secrets scan > .secrets.baseline

# 新しいシークレットの検出
detect-secrets audit .secrets.baseline
```

## 🚨 緊急時の対応

### クレデンシャルがコミットされた場合

1. **即座にリポジトリを無効化**
2. **コミット履歴から完全に削除**
3. **新しいクレデンシャルを発行**
4. **セキュリティ監査の実施**

```bash
# コミット履歴からファイルを完全に削除
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/credentials' \
  --prune-empty --tag-name-filter cat -- --all

# 強制プッシュ（注意: チームメンバーに事前通知）
git push origin --force --all
```

## 📋 セキュリティチェックリスト

- [ ] `.env` ファイルが `.gitignore` に含まれている
- [ ] クレデンシャルがコードにハードコーディングされていない
- [ ] 環境変数が適切に設定されている
- [ ] Pre-commit フックが設定されている
- [ ] 定期的なセキュリティ監査が実施されている
- [ ] チームメンバーがセキュリティポリシーを理解している

## 📚 参考資料

- [OWASP Security Guidelines](https://owasp.org/)
- [GitHub Security Best Practices](https://docs.github.com/en/github/security)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/)

## 🆘 セキュリティ問題の報告

セキュリティ問題を発見した場合は、以下の方法で報告してください：

1. **プライベートな方法で報告**（メール、セキュアチャット等）
2. **詳細な情報を提供**（問題の説明、影響範囲、再現手順）
3. **緊急度の評価**（低/中/高/緊急）
4. **対応計画の策定**

---

**セキュリティは全員の責任です。常に警戒心を持って開発を行いましょう。**
