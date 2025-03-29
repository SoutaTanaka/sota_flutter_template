import 'package:freezed_annotation/freezed_annotation.dart';

part 'exception.freezed.dart';

/// ドメイン例外の基底クラス
sealed class DomainException implements Exception {
  const DomainException();
}

/// 再試行可能なドメイン例外
@freezed
sealed class RetryableException
    with _$RetryableException
    implements DomainException {
  /// ネットワークエラー
  const factory RetryableException.network() = NetworkException;

  /// タイムアウトエラー
  const factory RetryableException.timeout() = TimeoutException;

  /// 不正な入力
  const factory RetryableException.invalidInput() = InvalidInputException;

  /// バリデーションエラー
  const factory RetryableException.validation() = ValidationException;

  /// データが存在しない
  const factory RetryableException.notFound() = NotFoundException;
}

/// 再試行不可能なドメイン例外
@freezed
sealed class UnretryableException
    with _$UnretryableException
    implements DomainException {
  /// 強制アップデート
  const factory UnretryableException.forceUpdate() = ForceUpdateException;

  /// メンテナンス
  const factory UnretryableException.maintenance() = MaintenanceException;

  /// ログイン期限切れ
  const factory UnretryableException.loginExpired() = LoginExpiredException;

  /// 未知のエラー
  const factory UnretryableException.unknown() = UnknownException;
}
