import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shake;
  final VoidCallback onComplete;

  const ShakeWidget({
    super.key,
    required this.child,
    required this.shake,
    required this.onComplete,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0).then((_) => widget.onComplete());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // This math formula creates the side-to-side "shiver" effect
        final double offset = (0.5 - (0.5 - _controller.value).abs()) * 2;
        final double sineValue =
            4 * (0.5 - (0.5 - Curves.bounceIn.transform(offset)).abs());

        return Transform.translate(
          offset: Offset(
            sineValue * 10,
            0,
          ), // Adjust '10' for more/less shake intensity
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
