import 'package:isar/isar.dart';

part 'stable_horde_task.g.dart';

@collection
class StableHordeTask {
  Id id = Isar.autoIncrement;

  String? imagePath;

  DateTime? firstShowProgressIndicatorTime;
  DateTime? estimatedCompletionTime;

  StableHordeTask();

  bool isComplete() {
    return imagePath != null;
  }
}
