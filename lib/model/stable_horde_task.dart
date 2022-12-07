import 'package:isar/isar.dart';

part 'stable_horde_task.g.dart';

@collection
class StableHordeTask {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  final String taskId;

  StableHordeTask(this.taskId);
}
