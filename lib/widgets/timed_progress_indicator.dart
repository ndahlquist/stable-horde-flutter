import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Animates a CircularProgressIndicator from 0 to 100%.
/// Finishes at completionTime.
class TimedProgressIndicator extends StatefulWidget {
  final DateTime startTime;
  final DateTime completionTime;

  const TimedProgressIndicator({
    super.key,
    required this.startTime,
    required this.completionTime,
  });

  @override
  State<TimedProgressIndicator> createState() => _TimedProgressIndicatorState();
}

class _TimedProgressIndicatorState extends State<TimedProgressIndicator>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime =
        DateTime.now().difference(widget.startTime).inMilliseconds;
    final totalTime =
        widget.completionTime.difference(widget.startTime).inMilliseconds;
    final progress = elapsedTime / totalTime;
    return CircularProgressIndicator(
      value: progress,
    );
  }
}
