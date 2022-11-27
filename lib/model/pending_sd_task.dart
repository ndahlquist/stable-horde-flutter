enum SdTaskStatus {
  pending,
  processing,
  done,
}

class PendingSdTask {
  final String? imageUrl;
  final SdTaskStatus status;
  final DateTime? startTime;
  final DateTime? estimatedCompletionTime;

  PendingSdTask(
    this.imageUrl,
    this.status,
    this.startTime,
    this.estimatedCompletionTime,
  );

  String description() {
    switch (status) {
      case SdTaskStatus.pending:
        return 'Queued...';
      case SdTaskStatus.processing:
        return 'Dreaming...';
      case SdTaskStatus.done:
        return 'Done';
    }
  }
}
