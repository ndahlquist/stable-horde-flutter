import 'package:isar/isar.dart';

part 'stable_horde_task.g.dart';

@collection
class StableHordeTask {
  Id id = Isar.autoIncrement;

  final String taskId;

  String? imageUrl;

  DateTime startTime;
  DateTime? estimatedCompletionTime;

  StableHordeTask(this.taskId, this.startTime);
}
