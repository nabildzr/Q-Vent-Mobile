import 'package:flutter/material.dart';

class LandingTabsScope extends InheritedWidget {
  final TabController controller;

  const LandingTabsScope({
    super.key,
    required this.controller,
    required super.child,
  });

  // methd statis untuk mendapatkan instance LandingTabsScope terdekat dari widget tree
  // mthod ini memungkinkan widget child untuk mengakses TabController yang disediakan oleh LandingTabsScope
  static LandingTabsScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LandingTabsScope>();
  }



  @override
  bool updateShouldNotify(LandingTabsScope oldWidget) =>
      controller != oldWidget.controller;
}