import 'package:isar/isar.dart';

part 'stable_horde_task.g.dart';

@collection
class StableHordeTask {
  Id id = Isar.autoIncrement;

  final String taskId;

  String? imageUrl;
  String? imagePath;

  DateTime? firstShowProgressIndicatorTime;
  DateTime? estimatedCompletionTime;

  StableHordeTask(this.taskId);
}
