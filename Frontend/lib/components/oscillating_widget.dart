import 'package:flutter/material.dart';

class OscillatingWidget extends StatefulWidget {
  final double amplitude;
  final Widget child;
  const OscillatingWidget({
    Key? key,
    required this.amplitude,
    required this.child,
  }) : super(key: key);

  @override
  _OscillatingWidgetState createState() => _OscillatingWidgetState();
}

class _OscillatingWidgetState extends State<OscillatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: 0,
      end: widget.amplitude,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) {
        return SizedBox.shrink(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              animation.value,
              0,
              widget.amplitude - animation.value,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
