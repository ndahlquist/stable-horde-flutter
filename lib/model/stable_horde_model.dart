class StableHordeBaseModel {
  final String name;
  final int workerCount;

  StableHordeBaseModel(this.name, this.workerCount);
}

class StableHordeModelDetails {
  final String description;
  final String previewImageUrl;

  StableHordeModelDetails(this.description, this.previewImageUrl);
}

class StableHordeModel extends StableHordeBaseModel {
  final String description;
  final String previewImageUrl;
  final String promptTemplate;

  StableHordeModel(
    name,
    workerCount,
    this.description,
    this.previewImageUrl,
    this.promptTemplate,
  ) : super(name, workerCount);
}
