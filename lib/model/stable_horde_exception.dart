class StableHordeException implements Exception {
  StableHordeException(this.message, this.payloadJson);

  final String message;
  final String payloadJson;

  @override
  String toString() => '$message $payloadJson';
}
