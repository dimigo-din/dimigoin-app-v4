class DFException implements Exception {
  final String message;

  DFException(this.message);
}

class NotDimigoMailException implements Exception {
  final String? message;

  NotDimigoMailException({this.message});
}

class PersonalInformationNotRegisteredException implements Exception {
  final String? message;

  PersonalInformationNotRegisteredException({this.message});
}

class GoogleOauthCodeInvalidException implements Exception {
  final String? message;

  GoogleOauthCodeInvalidException({this.message});
}

class PasswordInvalidException implements Exception {
  final String? message;

  PasswordInvalidException({this.message});
}

class WrongPasscodeException implements Exception {
  final String? message;

  WrongPasscodeException({this.message});
}

class StayNotInApplyPeriodException implements Exception {
  final String? message;

  StayNotInApplyPeriodException({this.message});
}

class StayAlreadyAppliedException implements Exception {
  final String? message;

  StayAlreadyAppliedException({this.message});
}

class StaySeatDuplicationException implements Exception {
  final String? message;

  StaySeatDuplicationException({this.message});
}

class StaySeatNotAllowedException implements Exception {
  final String? message;

  StaySeatNotAllowedException({this.message});
}

class LaundryApplyIsAfterEightAMException implements Exception {
  final String? message;

  LaundryApplyIsAfterEightAMException({this.message});
}

class LaundryApplyAlreadyExistsException implements Exception {
  final String? message;

  LaundryApplyAlreadyExistsException({this.message});
}

class PermissionDeniedResourceGradeException implements Exception {
  final String? message;

  PermissionDeniedResourceGradeException({this.message});
}

class LaundryMachineAlreadyTakenException implements Exception {
  final String? message;

  LaundryMachineAlreadyTakenException({this.message});
}

class PermissionDeniedResourceException implements Exception {
  final String? message;

  PermissionDeniedResourceException({this.message});
}

class ResourceNotFoundException implements Exception {
  final String? message;

  ResourceNotFoundException({this.message});
}

class ProvidedTimeInvalidException implements Exception {
  final String? message;

  ProvidedTimeInvalidException({this.message});
}

class FrigoPeriodNotExistsForGradeException implements Exception {
  final String? message;

  FrigoPeriodNotExistsForGradeException({this.message});
}

class FrigoPeriodNotInApplyPeriodException implements Exception {
  final String? message;

  FrigoPeriodNotInApplyPeriodException({this.message});
}

class FrigoAlreadyAppliedException implements Exception {
  final String? message;

  FrigoAlreadyAppliedException({this.message});
}

class ResourceAlreadyExists implements Exception {
  final String? message;

  ResourceAlreadyExists({this.message});
}