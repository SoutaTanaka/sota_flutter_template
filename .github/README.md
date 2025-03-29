# GitHub Actions ワークフロー

このプロジェクトでは以下のGitHub Actionsワークフローを使用しています：

## Flutter CI ワークフロー

`flutter_ci.yml`ファイルで定義されているこのワークフローは以下の機能を提供します：

- Dartコードのフォーマットチェック
- プロジェクト全体の静的コード解析（lint）
- すべてのパッケージのテスト実行

すべての検証処理を1つのワークフローに統合することで、CI/CDのプロセスを効率化しています。

### 実行タイミング
- mainブランチへのpush
- mainブランチへのプルリクエスト

### 主な処理
1. コードのチェックアウト
2. `.fvmrc`ファイルからFlutterバージョンを読み取り
3. 読み取ったバージョンでFlutter環境のセットアップ
4. 依存関係のインストール（melosを使用）
5. フォーマットチェックの実行
6. 静的解析の実行
7. テストの実行

## ローカルでの実行方法

ワークフローと同じ処理をローカルで実行するには以下のコマンドを使用してください：

```bash
# Melosをインストール
flutter pub global activate melos 7.0.0-dev.7

# 依存関係の解決
melos bootstrap

# フォーマットチェック
melos run format:check

# 静的解析の実行
melos run analyze

# テストの実行
melos run test

# フォーマットの適用
melos run format
```

## FVMについて

このプロジェクトはFlutter Version Manager (FVM)を使用してFlutterのバージョンを管理しています。`.fvmrc`ファイルに指定されたバージョンがCI/CDワークフローでも使用されます。ローカル開発環境でも同じバージョンを使用するために、FVMのインストールを推奨します。

```bash
# FVMのインストール
dart pub global activate fvm

# プロジェクトで指定されたFlutterバージョンを使用
fvm use
``` 