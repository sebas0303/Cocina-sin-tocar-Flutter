import 'dart:async';
import 'package:flutter/material.dart';
import 'cocina_component_contract.dart';

/// Temporizador de cuenta atrás por paso basado en [Stream] (RA1.g, RA3.b-f).
class StepTimer extends StatefulWidget implements CocinaInteractiveComponent {
  final Duration duration;
  final bool autoStart;
  final VoidCallback onFinished;

  StepTimer({
    super.key,
    required this.duration,
    this.autoStart = false,
    required this.onFinished,
  }) : assert(duration.inSeconds > 0, 'duration debe ser mayor que 0 segundos');

  @override
  String get semanticDescription => 'Temporizador de ${duration.inSeconds} segundos';

  @override
  bool get supportsHandsFree => true;

  @override
  State<StepTimer> createState() => StepTimerState();
}

class StepTimerState extends State<StepTimer> {
  late int _remainingSeconds;
  bool _isRunning = false;
  StreamSubscription<int>? _sub;

  bool get isRunning => _isRunning;
  int get remainingSeconds => _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    if (widget.autoStart) startOrResume();
  }

  void togglePause() => _isRunning ? pause() : startOrResume();

  void startOrResume() {
    if (_isRunning || _remainingSeconds <= 0) return;
    setState(() => _isRunning = true);
    _sub?.cancel();
    _sub = Stream<int>.periodic(const Duration(seconds: 1), (x) => x).listen((_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
        if (_remainingSeconds == 0) {
          _isRunning = false;
          _sub?.cancel();
          widget.onFinished();
        }
      });
    });
  }

  void pause() {
    _sub?.cancel();
    if (mounted) setState(() => _isRunning = false);
  }

  void reset() {
    _sub?.cancel();
    if (mounted) {
      setState(() {
        _isRunning = false;
        _remainingSeconds = widget.duration.inSeconds;
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mins = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$mins:$secs', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            ElevatedButton(
              key: const Key('timer_toggle_btn'),
              onPressed: togglePause,
              child: Text(_isRunning ? 'Pausar' : 'Iniciar'),
            ),
            IconButton(
              key: const Key('timer_reset_btn'),
              onPressed: reset,
              icon: const Icon(Icons.replay),
            ),
          ],
        ),
      ),
    );
  }
}
