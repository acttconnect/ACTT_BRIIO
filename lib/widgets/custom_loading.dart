import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  final double width;
  final double height;

  const CustomLoading({
    super.key,
    this.width = 100,
    this.height = 100,
  });

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Fast spin
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: Image.asset(
          'assets/logo_o.png',
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
