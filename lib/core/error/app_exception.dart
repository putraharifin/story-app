/// Error returned by the API. [message] is null when the server gave none.
class ApiException implements Exception {
  const ApiException([this.message]);

  final String? message;
}

/// No connection, timeout, or any other transport problem.
class NetworkException implements Exception {
  const NetworkException();
}
