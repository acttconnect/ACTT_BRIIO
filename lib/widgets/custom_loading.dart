import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  final double width;
  final double height;

  const CustomLoading({
    super.key,
    this.width = 60,
    this.height = 60,
  });

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset(
          'assets/logo_transparent.png',
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
