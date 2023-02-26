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
  int? steps;

  String? imageFilename;

  DateTime? firstShowProgressIndicatorTime;
  DateTime? estimatedCompletionTime;

  bool failed = false;
  String? errorMessage;

  StableHordeTask(this.prompt, this.negativePrompt, this.model, this.steps);

  bool isComplete() {
    return imageFilename != null;
  }
}
