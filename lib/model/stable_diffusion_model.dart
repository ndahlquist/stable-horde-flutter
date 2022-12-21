class StableDiffusionModel {
  final String name;
  final int workerCount;

  String? description;
  String? previewImageUrl;

  StableDiffusionModel(this.name, this.workerCount);
}
