import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassSettings {
  final double thickness;
  final double blur;
  final double lightAngle;
  final Color glassColor;

  const LiquidGlassSettings({
    this.thickness = 10,
    this.blur = 5,
    this.lightAngle = 0.8 * 3.14,
    required this.glassColor,
  });
}

class LiquidRoundedSuperellipse {
  final double borderRadius;
  const LiquidRoundedSuperellipse({required this.borderRadius});
}

class LiquidGlassLayer extends StatelessWidget {
  final LiquidGlassSettings settings;
  final Widget child;

  const LiquidGlassLayer({
    super.key,
    required this.settings,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _LiquidGlassSettingsProvider(
      settings: settings,
      child: child,
    );
  }
}

class _LiquidGlassSettingsProvider extends InheritedWidget {
  final LiquidGlassSettings settings;

  const _LiquidGlassSettingsProvider({
    required this.settings,
    required super.child,
  });

  static LiquidGlassSettings? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LiquidGlassSettingsProvider>()?.settings;
  }

  @override
  bool updateShouldNotify(_LiquidGlassSettingsProvider oldWidget) {
    return settings != oldWidget.settings;
  }
}

class LiquidGlass extends StatelessWidget {
  final LiquidRoundedSuperellipse shape;
  final Widget child;

  const LiquidGlass({
    super.key,
    required this.shape,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final settings = _LiquidGlassSettingsProvider.of(context) ?? const LiquidGlassSettings(
      thickness: 10,
      blur: 5,
      lightAngle: 0.8 * 3.14,
      glassColor: Colors.transparent,
    );

    final radius = shape.borderRadius;

    Widget result = child;

    // Apply container styling to mimic the bevel border and glass color
    result = Container(
      decoration: BoxDecoration(
        color: settings.glassColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 0.5,
        ),
      ),
      child: child,
    );

    // Apply glass blur if blur > 0
    if (settings.blur > 0) {
      result = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: settings.blur, sigmaY: settings.blur),
          child: result,
        ),
      );
    }

    return result;
  }
}
