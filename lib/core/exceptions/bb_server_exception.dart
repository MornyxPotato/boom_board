class BBServerException implements Exception {
  int code;
  String errorType;
  dynamic data;

  BBServerException({
    required this.code,
    required this.errorType,
    this.data,
  });

  @override
  String toString() {
    return 'BBServerException code: $code, errorType: $errorType, data: $data';
  }
}
