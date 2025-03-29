# そたFlutterテンプレート

クリーンアーキテクチャに基づいたマルチパッケージ構成のFlutterプロジェクトテンプレートです。

## プロジェクト構成

このプロジェクトは、以下のようなマルチパッケージ構成で設計されています：

```
sota_flutter_template/
├── app/                  # メインアプリケーション
├── packages/             # 各種パッケージ
│   ├── domain/           # ドメイン層
│   ├── data/             # データ層
│   │   ├── adapter/      # リポジトリ実装
│   │   ├── api/          # API通信関連
│   │   └── local/        # ローカルストレージ関連
│   └── presentation/     # プレゼンテーション層
│       ├── component/   # 共通UIコンポーネント
│       └── page/         # 画面コンポーネント
└── pubspec.yaml          # ワークスペース設定
```

## アーキテクチャ

このプロジェクトは、クリーンアーキテクチャの原則に基づいて設計されています。各層の責務は以下の通りです：

### ドメイン層
- **domain**: ドメインモデルとビジネスロジックを提供します

### データ層
- **adapter**: リポジトリインターフェースの実装を提供します
- **api**: API通信のためのクライアントとデータ構造を提供します
- **local**: ローカルストレージへのアクセスを提供します

### プレゼンテーション層
- **component**: 再利用可能なUIコンポーネントを提供します
- **page**: アプリケーションの画面コンポーネントを提供します

## 依存関係の方向

依存関係は以下のルールに従っています：

1. 内側の層は外側の層に依存してはいけません
   - domain → data, presentation (禁止)
   - data → presentation (禁止)
   - presentation → data (禁止)

2. 許可される依存関係
   - presentation → domain
   - data → domain
   - app → 全てのパッケージ

## 開発環境セットアップ

### セットアップ手順

1. リポジトリのクローン
```bash
git clone <repository-url>
cd sota_flutter_template
```

2. FVMを使用して.fvmrcに設定されたバージョンを使用
```bash
fvm use
```

3. 依存関係のインストール
```bash
fvm flutter pub get
```


## コード規約

- [very_good_analysis](https://pub.dev/packages/very_good_analysis)に基づいたリントルールが適用されています
- 各パッケージには個別のanalysis_options.yamlが含まれており、必要に応じてカスタマイズされています

## テスト

各パッケージには独自のテストディレクトリがあり、ユニットテストとウィジェットテストを含めることができます。
