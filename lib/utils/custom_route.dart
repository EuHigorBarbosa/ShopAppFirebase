import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    required WidgetBuilder builderMy,
    RouteSettings? settingsMy,
  }) : super(builder: builderMy, settings: settingsMy);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }
}
