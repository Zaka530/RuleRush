import 'dart:async';
import 'package:flutter/material.dart';

class ReusableCountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onFinished;
  final TextStyle? textStyle;

  const ReusableCountdownTimer({
    super.key,
    required this.duration,
    this.onFinished,
    this.textStyle,
  });

  @override
  State<ReusableCountdownTimer> createState() => _ReusableCountdownTimerState();
}

class _ReusableCountdownTimerState extends State<ReusableCountdownTimer> {
  late Duration remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (remaining.inSeconds > 0) {
            remaining -= const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            widget.onFinished?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(remaining),
      style: widget.textStyle ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
