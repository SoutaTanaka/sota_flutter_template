// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RetryableException {


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RetryableException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RetryableException()';
  }


}

/// @nodoc
class $RetryableExceptionCopyWith<$Res> {
  $RetryableExceptionCopyWith(RetryableException _,
      $Res Function(RetryableException) __);
}


/// @nodoc


class NetworkException implements RetryableException {
  const NetworkException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NetworkException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RetryableException.network()';
  }


}


/// @nodoc


class TimeoutException implements RetryableException {
  const TimeoutException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TimeoutException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RetryableException.timeout()';
  }


}


/// @nodoc


class InvalidInputException implements RetryableException {
  const InvalidInputException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidInputException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RetryableException.invalidInput()';
  }


}


/// @nodoc


class ValidationException implements RetryableException {
  const ValidationException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ValidationException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RetryableException.validation()';
  }


}


/// @nodoc


class NotFoundException implements RetryableException {
  const NotFoundException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NotFoundException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RetryableException.notFound()';
  }


}


/// @nodoc
mixin _$UnretryableException {


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UnretryableException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UnretryableException()';
  }


}

/// @nodoc
class $UnretryableExceptionCopyWith<$Res> {
  $UnretryableExceptionCopyWith(UnretryableException _,
      $Res Function(UnretryableException) __);
}


/// @nodoc


class ForceUpdateException implements UnretryableException {
  const ForceUpdateException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ForceUpdateException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UnretryableException.forceUpdate()';
  }


}


/// @nodoc


class MaintenanceException implements UnretryableException {
  const MaintenanceException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MaintenanceException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UnretryableException.maintenance()';
  }


}


/// @nodoc


class LoginExpiredException implements UnretryableException {
  const LoginExpiredException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoginExpiredException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UnretryableException.loginExpired()';
  }


}


/// @nodoc


class UnknownException implements UnretryableException {
  const UnknownException();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UnknownException);
  }


  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UnretryableException.unknown()';
  }


}


// dart format on
