import 'package:domain/src/common/exception.dart';
import 'package:meta/meta.dart';

/// 処理結果を表現する型
///
/// [T] - 成功時の型
@immutable
sealed class Result<T> {
  const Result();

  /// 成功の結果を作成
  static Success<T> success<T>(T value) => Success<T>(value);

  /// 失敗の結果を作成
  static Failure<T> failure<T>(DomainException exception) =>
      Failure<T>(exception);

  /// 結果が成功かどうかを返す
  bool get isSuccess => this is Success<T>;

  /// 結果が失敗かどうかを返す
  bool get isFailure => this is Failure<T>;

  /// 結果に応じて関数を実行
  ///
  /// [onSuccess] - 成功時に実行する関数
  /// [onFailure] - 失敗時に実行する関数
  void when({
    required void Function(T value) onSuccess,
    required void Function(DomainException exception) onFailure,
  }) {
    if (this is Success<T>) {
      onSuccess((this as Success<T>).value);
    } else if (this is Failure<T>) {
      onFailure((this as Failure<T>).exception);
    }
  }

  /// 成功時に関数を実行
  ///
  /// [onSuccess] - 成功時に実行する関数
  /// 元のResultをそのまま返す
  void onSuccess(void Function(T value) onSuccess) {
    if (this is Success<T>) {
      onSuccess((this as Success<T>).value);
    }
  }

  /// 失敗時に関数を実行
  ///
  /// [onFailure] - 失敗時に実行する関数
  /// 元のResultをそのまま返す
  void onFailure(void Function(DomainException exception) onFailure) {
    if (this is Failure<T>) {
      onFailure((this as Failure<T>).exception);
    }
  }
}

/// 成功を表すクラス
@immutable
final class Success<T> extends Result<T> {

  /// 成功のインスタンスを作成
  const Success(this.value);
  /// 成功時の値
  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success(value: $value)';
}

/// 失敗を表すクラス
@immutable
final class Failure<T> extends Result<T> {

  /// 失敗のインスタンスを作成
  const Failure(this.exception);
  /// 失敗時の例外
  final DomainException exception;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure<T> && other.exception == exception;
  }

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'Failure(exception: $exception)';
}
