# ドメインモデルの設計・実装ガイドライン

## 1. ドメインモデルとは

ドメインモデルはアプリケーションが扱うビジネスロジックの中心となるデータ構造とルールを表現したものです。ドメインモデルはビジネスロジックを正確に表現し、外部の技術的な関心事から分離することを目的としています。

### 1.1 ドメインモデルの重要性

- **ビジネスルールの一元管理**: ビジネスルールをドメインモデルに集約することで、一貫性を保ちやすくなります
- **変更に強い設計**: 技術的な実装から分離することで、ビジネスルールの変更が容易になります
- **テスト容易性**: ドメインモデルは外部依存がなく、単体テストが容易です
- **共通言語**: 開発者とドメイン専門家が同じ用語と概念で会話できるようになります

## 2. フォルダ構造とファイル命名規則

本プロジェクトでは、ドメインモデルはドメイン単位でまとめて管理します。

### 2.1 基本的なフォルダ構造

```
packages/
  domain/
    lib/
      src/
        [domain_name]/
          entities/          # ドメインのエンティティ
          value_objects/     # 値オブジェクト
          failures/          # ドメイン固有のエラー定義
          repository/        # リポジトリインターフェース
```

例えば、ユーザードメインの場合：

```
packages/
  domain/
    lib/
      src/
        user/
          entities/
            user.dart
            user.freezed.dart
          value_objects/
            email.dart
            password.dart
          failures/
            user_failure.dart
          repository/
            user_repository.dart
```

### 2.2 ファイル命名規則

- エンティティ: `[entity_name].dart`
- 値オブジェクト: `[value_object_name].dart`
- リポジトリインターフェース: `[entity_name]_repository.dart`
- 失敗ケース: `[domain_name]_failure.dart`

## 3. freezedを使ったドメインモデルの実装

freezedはイミュータブルなオブジェクトを簡単に作成できるパッケージです。本プロジェクトではドメインモデルの実装にfreezedを使用します。

### 3.1 基本的な実装パターン

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// ユーザーを表現するエンティティ
@freezed
class User with _$User {
  const factory User({
    /// ユーザーID
    required String id,
    
    /// ユーザー名
    required String userName,
    
    /// メールアドレス
    required String email,
    
    /// アカウント作成日時
    required DateTime createdAt,
  }) = _User;
}
```

### 3.2 fromJsonの非実装について

本プロジェクトでは、ドメインモデルに`fromJson`と`toJson`を実装しません。これらはアダプタ層の責務とします。

```dart
// ❌ ドメインモデルでは以下の記述は行わない
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String userName,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## 4. パラメータのドキュメント記述

ドメインモデルの各パラメータには、明確なドキュメントを付与することが必須です。

### 4.1 ドキュメントの記述ルール

- 全てのパラメータに3行スラッシュコメント（`///`）を使用
- パラメータの目的や制約条件を明記
- 値の範囲や特殊な条件がある場合は記載
- 単位や形式が必要な場合は明記（例: 日付形式、金額の単位など）

### 4.2 ドキュメント記述例

```dart
@freezed
class Product with _$Product {
  const factory Product({
    /// 商品ID
    /// UUIDv4形式の文字列
    required String id,
    
    /// 商品名
    /// 1文字以上50文字以下
    required String name,
    
    /// 商品価格（円）
    /// 0以上の整数
    required int price,
    
    /// 商品説明
    /// null可能。最大500文字
    String? description,
    
    /// 在庫数
    /// 0以上の整数
    required int stockQuantity,
    
    /// 商品が有効かどうか
    /// trueの場合のみ検索結果に表示される
    required bool isActive,
    
    /// 商品カテゴリID
    /// 外部キーとして機能
    required String categoryId,
    
    /// 最終更新日時
    required DateTime updatedAt,
  }) = _Product;
}
```

## 9. 注意点とよくある間違い

### 9.1 避けるべき実装パターン

- **ミュータブル（可変）なプロパティ**: freezedを使用せず、通常のクラスでsetterを定義するなど
- **複雑すぎるエンティティ**: 多すぎる責務を持つエンティティは分割を検討する
- **アプリケーションロジックの混入**: UIやデータ永続化に関するロジックはドメインモデルに含めない
- **技術的な関心事との結合**: 特定のデータベースやフレームワークに依存する実装

## 10. まとめ

優れたドメインモデルは以下の特徴を持ちます：

- ビジネスルールをコードとして明確に表現している
- 技術的な詳細から分離されている
- イミュータブルで、副作用がない
- 自己完結的で、外部依存が少ない
- テストが容易
- 拡張性が高い

本ガイドラインに従い、プロジェクト内で一貫したドメインモデル設計を実現してください。 