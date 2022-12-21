import 'package:isar/isar.dart';

part 'stable_horde_task.g.dart';

@collection
class StableHordeTask {
  Id id = Isar.autoIncrement;

  String prompt;
  String model;
  String negativePrompt;

  String? imageFilename;

  DateTime? firstShowProgressIndicatorTime;
  DateTime? estimatedCompletionTime;

  StableHordeTask(this.prompt, this.negativePrompt, this.model);

  bool isComplete() {
    return imageFilename != null;
  }
}
