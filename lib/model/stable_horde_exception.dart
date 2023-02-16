class StableHordeException implements Exception {
  final String message;
  final int statusCode;
  final String payloadJson;

  StableHordeException(this.message, this.statusCode, this.payloadJson);

  @override
  String toString() => '$statusCode $message $payloadJson';
}
