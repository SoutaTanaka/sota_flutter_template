# 依存性注入（DI）フレームワーク Shovel の利用ガイド

## 1. 依存性注入（DI）パターンとは

依存性注入は、コンポーネント間の依存関係を外部から注入することでコードの結合度を下げるデザインパターンです。コンポーネントが自身で依存関係を生成せず、外部から提供されることで、テスト容易性や保守性が向上します。

### サービスロケーターパターンとの違い

| 依存性注入パターン | サービスロケーターパターン |
|-------------------|--------------------------|
| 依存関係を明示的にコンストラクタなどで受け取る | グローバルなレジストリから依存関係を取得する |
| 依存関係が明確で追跡しやすい | 依存関係が隠れており追跡が難しい |
| テスト時にモックの注入が容易 | テスト時にグローバル状態の管理が必要 |
| コンパイル時の型安全性が高い | 実行時エラーのリスクが高い |

**サービスロケーターの問題点:**
```dart
// サービスロケーターパターン（非推奨）
class UserRepository {
  void saveUser(User user) {
    // グローバルなサービスロケーターから依存関係を取得
    final database = ServiceLocator.get<Database>();
    database.save(user);
  }
}
```

このアプローチでは、`UserRepository`クラスがどのような依存関係を持っているかが明確でなく、テストが困難になります。

## 2. コンストラクタインジェクション

依存性注入の主要な手法の一つで、最も推奨される方法です。依存関係をクラスのコンストラクタを通じて注入します。

```dart
class UserRepository {
  final ApiClient _apiClient;
  
  // コンストラクタで依存関係を受け取る
  UserRepository(this._apiClient);
  
  Future<User> getUser(String id) async {
    // _apiClientを使用した実装
    return await _apiClient.fetchUser(id);
  }
}
```

### 利点
- 依存関係が明示的で、クラスが必要とするものが一目瞭然
- 不変性を保証できる（finalフィールド）
- テスト時にモックオブジェクトの注入が容易
- オブジェクト生成時に必要な依存関係がすべて揃っていることを保証

## 3. Shovelを使用した依存性注入の実装

Shovelは軽量な依存性注入フレームワークで、直感的なAPIを提供します。Kotlinの「Kodein」にインスパイアされています。

### 3.1 セットアップ

```yaml
dependencies:
  shovel: ^1.0.0
```

### 3.2 基本的な使い方

```dart
// 依存関係の定義
final ground = Ground()
  ..bury<ApiClient>((shovel) => ApiClient())
  ..bury<UserRepository>((shovel) => UserRepository(shovel.dig<ApiClient>()))
  ..bury<UserService>((shovel) => UserService(shovel.dig<UserRepository>()));

// 依存関係の解決
final shovel = ground.shovel();
final userService = shovel.dig<UserService>();
```

### 3.3 パラメータ付き依存関係

```dart
final ground = Ground()
  ..buryWithArg<ApiClient, String>((shovel, apiKey) => ApiClient(apiKey: apiKey))
  ..bury<UserRepository>((shovel) => UserRepository(
        shovel.digWithArg<ApiClient, String>('api-key-value'),
      ));
```

### 3.4 複数のGroundの結合

```dart
final networkGround = Ground()
  ..bury<ApiClient>((shovel) => ApiClient());

final databaseGround = Ground()
  ..bury<DatabaseService>((shovel) => DatabaseService());

final appGround = Ground()
  ..reclaim(networkGround)  // reclaimメソッドを使用
  ..reclaim(databaseGround) // reclaimメソッドを使用
  ..bury<AppService>((shovel) => AppService(
        shovel.dig<ApiClient>(),
        shovel.dig<DatabaseService>(),
      ));
```

## 4. アーキテクチャにおけるDIの位置づけ

### 4.1 クリーンアーキテクチャでの実装例

```dart
// ドメイン層（依存関係を持たない）
abstract interface class UserRepository {
  Future<User> getUser(String id);
}

// データ層
class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;
  
  UserRepositoryImpl(this._apiClient);
  
  @override
  Future<User> getUser(String id) async {
    // 実装
    return await _apiClient.fetchUser(id);
  }
}

// DIの設定
final ground = Ground()
  ..bury<ApiClient>((shovel) => ApiClient())
  // インターフェースに対して実装を紐付け
  ..bury<UserRepository>((shovel) => UserRepositoryImpl(shovel.dig<ApiClient>()));
```

### 4.2 プロジェクト内での推奨プラクティス

- すべての依存関係はインターフェースを通して解決する
- 実装の詳細はDIコンテナの設定時のみに露出させる
- ビジネスロジックはDIコンテナに依存しない
- DIコンテナの初期化はアプリケーションの起動時に一度だけ行う

## 5. 注意点

### 5.1 循環依存の防止

循環依存（AがBに依存し、BがAに依存するような状態）は避けるべきです。Shovelでは循環依存があると実行時エラーが発生します。

設計を見直し、以下のような解決策を検討してください：
- 共通のインターフェースを抽出する
- メディエーターパターンを導入する
- 依存関係を一方向にする


## 6. プロジェクト固有のDI実装ルール

本プロジェクトでは、パッケージごとにshovelのGroundを定義し、それらを統合するアプローチを採用しています。

### 6.1 パッケージ固有のGroundファイル

各パッケージは以下の命名規則に従って依存性を定義する必要があります。

- ファイル名: `<パッケージ名>_ground.dart`
- 配置場所: `packages/<パッケージ名>/src/`

注意点として、domain層はmodel及びrepositoryのinterfaceの定義のみを行っているので、Groundファイルは存在しません。
componentも同様です。

例: 
- `packages/data/adapter/src/adapter_ground.dart`
- `packages/data/api/src/api_ground.dart`
- `packages/data/local/src/local_ground.dart`
- `packages/presentation/src/presentation_ground.dart`

### 6.2 パッケージGroundの構造

```dart
// packages/data/adapter/src/adapter_ground.dart
import 'package:shovel/shovel.dart';

final adapterGround = Ground()
  ..bury<UserRepository>((shovel) => UserRepositoryImpl(shovel.dig<UserApiClient>()));
```

### 6.3 パッケージGroundのエクスポート

各パッケージはパッケージ名.dartというファイルを作成し、その中でGroundをエクスポートします。

```dart
// packages/data/adapter/lib/adapter.dart
export 'src/adapter_ground.dart';
```

### 6.4 アプリケーションでの統合

アプリケーションのエントリーポイントで各パッケージのGroundを統合します：

```dart
// app/lib/di/app_ground.dart
import 'package:data/adapter/adapter.dart';
import 'package:data/api/api.dart';
import 'package:data/local/local.dart';
import 'package:presentation/presentation.dart';
import 'package:shovel/shovel.dart';

final appShovel = (Ground()
      ..reclaim(adapterGround)
      ..reclaim(apiGround)
      ..reclaim(localGround) 
      ..reclaim(presentationGround)).shovel();
```

### 6.5 DIの使用

アプリケーションコード内でDIを使用する際は以下のパターンに従ってください：

```dart
// DIを使用するクラス
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DIコンテナからインスタンスを取得
    final userViewModel = appShovel.dig<UserViewModel>();
    
    return // ウィジェットの実装
  }
}
```

### 6.6 パッケージGround作成のベストプラクティス

1. **モジュール性を維持する**: 各パッケージは自身が所有するクラスのみを登録する
2. **依存方向を守る**: パッケージの依存方向に従って登録を行う（ドメイン→データ→プレゼンテーション）
3. **インターフェースを使用する**: 常にインターフェースに対して実装を登録する
4. **テスト容易性**: テスト時に差し替えやすいように設計する
5. **明確な命名**: 登録するクラスの役割が分かる命名を行う

## 7. まとめ

依存性注入パターンとShovelフレームワークを適切に活用することで、以下のメリットが得られます：

- コードの結合度が低下し、テスト容易性が向上する
- 依存関係が明示的になり、コードの理解が容易になる
- 実装の詳細をビジネスロジックから隠蔽できる
- 機能拡張やリファクタリングが容易になる

このガイドラインに従い、プロジェクト内での一貫した依存性管理を実現してください。 