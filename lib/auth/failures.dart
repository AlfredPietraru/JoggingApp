enum CreateUserFailure {
  noFailureAtAll,
  unknownFailure,
  emailInUseFailure,
  invalidEmailFailure,
  operationNotPermittedFailure,
  weakPasswordFailure,
  invalidFirstName,
  invalidLastName,
  noInternetConnection,
  invalidDescription,
}

enum ChangePasswordFailure {
  unknownFailure,
  tooWeakFailure,
  authorizationFailure,
  wrongPasswordFailure,
}

enum LoginFailure {
  noFailureAtAll,
  noDataInsertedYet,
  wrongCredentials,
  noInternetConnection,
  unknown,
  invalidEmail,
  invalidPassword,
}

enum ReauthFailure {
  unknown,
  credentials,
}

enum DeleteAccountFailure {
  unknown,
  unauthorized,
}
