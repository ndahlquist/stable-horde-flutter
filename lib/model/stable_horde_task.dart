import 'package:isar/isar.dart';

part 'stable_horde_task.g.dart';

@collection
class StableHordeTask {
  Id dbId = Isar.autoIncrement;

  String prompt;
  String model;
  String negativePrompt;

  // Id used to reference this task via the stable horde API.
  String? stableHordeId;

  int? seed;

  String? imageFilename;

  DateTime? firstShowProgressIndicatorTime;
  DateTime? estimatedCompletionTime;

  bool failed = false;

  StableHordeTask(this.prompt, this.negativePrompt, this.model);

  bool isComplete() {
    return imageFilename != null;
  }
}
