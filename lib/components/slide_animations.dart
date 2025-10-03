// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class RightLeftSlide extends StatefulWidget {
  final double delay;
  final Widget child;

  const RightLeftSlide({Key? key, this.delay = 0, required this.child})
      : super(key: key);

  @override
  _RightLeftSlideState createState() => _RightLeftSlideState();
}

class _RightLeftSlideState extends State<RightLeftSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
    _translate =
        Tween<Offset>(begin: const Offset(30, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      _controller.forward();
    });
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
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _translate.value,
            child: child,
          ),
        );
      },
    );
  }
}

class TopBottomSlide extends StatefulWidget {
  final double delay;
  final Widget child;

  const TopBottomSlide({Key? key, this.delay = 0, required this.child})
      : super(key: key);

  @override
  _TopBottomSlideState createState() => _TopBottomSlideState();
}

class _TopBottomSlideState extends State<TopBottomSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
    _translate =
        Tween<Offset>(begin: const Offset(0, -30), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      _controller.forward();
    });
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
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _translate.value,
            child: child,
          ),
        );
      },
    );
  }
}

class LeftRightSlide extends StatefulWidget {
  final double delay;
  final Widget child;

  const LeftRightSlide({Key? key, this.delay = 0, required this.child})
      : super(key: key);

  @override
  _LeftRightSlideState createState() => _LeftRightSlideState();
}

class _LeftRightSlideState extends State<LeftRightSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _translate = Tween<Offset>(begin: const Offset(-30, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      _controller.forward();
    });
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
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          offset: _translate.value,
          child: child,
        );
      },
    );
  }
}



class BottomTopSlide extends StatefulWidget {
  final double delay;
  final Widget child;

  const BottomTopSlide({Key? key, this.delay = 0, required this.child})
      : super(key: key);

  @override
  _BottomTopSlideState createState() => _BottomTopSlideState();
}

class _BottomTopSlideState extends State<BottomTopSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
    _translate = Tween<Offset>(begin: const Offset(0, 30), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      _controller.forward();
    });
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
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _translate.value,
            child: child,
          ),
        );
      },
    );
  }
}
