
class StableHordeException implements Exception {
  StableHordeException(this.message);

  final String message;

  @override
  String toString() => message;
}