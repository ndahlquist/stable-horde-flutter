class StableHordeBaseModel {
  final String name;
  final int workerCount;

  StableHordeBaseModel(this.name, this.workerCount);
}

class StableHordeModel extends StableHordeBaseModel {
  final String description;
  final String previewImageUrl;

  StableHordeModel(
    name,
    workerCount,
    this.description,
    this.previewImageUrl,
  ) : super(name, workerCount);
}
