import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

typedef FlipCardBuilder = Widget Function(BuildContext context, bool isFront);

class FlipCard extends StatefulWidget {
  final FlipCardBuilder builder;
  final Duration duration;
  final bool flipOnTouch;
  final bool autoFlip;
  final Duration flipDelay;
  final bool infinityFlip;

  const FlipCard({
    super.key,
    required this.builder,
    this.duration = const Duration(milliseconds: 600),
    this.flipOnTouch = true,
    this.autoFlip = false,
    this.flipDelay = const Duration(seconds: 3),
    this.infinityFlip = false,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _maybeScheduleAuto();
  }

  void _maybeScheduleAuto() {
    _autoTimer?.cancel();
    if (widget.autoFlip || widget.infinityFlip) {
      _autoTimer = Timer(widget.flipDelay, _autoFlipOnceThenMaybeLoop);
    }
  }

  void _autoFlipOnceThenMaybeLoop() {
    if (!mounted) return;
    _triggerFlip().whenComplete(() {
      if (mounted && widget.infinityFlip) {
        _maybeScheduleAuto(); // schedule next
      }
    });
  }

  Future<void> _triggerFlip() async {
    if (!_controller.isAnimating) {
      if (_controller.value == 0) {
        await _controller.forward();
      } else {
        await _controller.reverse();
      }
    }
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flipDelay != widget.flipDelay ||
        oldWidget.autoFlip != widget.autoFlip ||
        oldWidget.infinityFlip != widget.infinityFlip) {
      _maybeScheduleAuto();
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.flipOnTouch ? _triggerFlip : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFront = _animation.value < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? widget.builder(context, true)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: widget.builder(context, false),
                  ),
          );
        },
      ),
    );
  }
}
